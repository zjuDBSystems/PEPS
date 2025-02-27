#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "utils/array.h"
#include "catalog/pg_type.h"
#include "optimizer/planner.h"
#include <math.h>
#include <time.h>
#include <cblas.h>
// #include "mkl.h"

#include "aqua_configs.h"
#include "model_buffer.h"
#include <omp.h>

extern ArrayType *float4construct_md_array_ncpy(int size,
                                                int ndims,
                                                int *dims,
                                                int *lbs,
                                                Oid elmtype);

PG_FUNCTION_INFO_V1(conv_text);
Datum conv_text(PG_FUNCTION_ARGS)
{
    openblas_set_num_threads(GEMM_THREADS);
    int width, height, kernel_H, kernel_W, stride, padding_H, padding_W;
    int out_width, out_height, out_nelems;
    int f_dims[2];

    ArrayType *array_input_f = PG_GETARG_ARRAYTYPE_P(1);
    Oid elemtype = array_input_f->elemtype;
    int *dims = ARR_DIMS(array_input_f);
    int num_channel = 1;
    int nelems_channel = dims[0] * dims[1];
    float4 *input_f = (float4 *)ARR_DATA_PTR(array_input_f);

    // im2col
    kernel_H = PG_GETARG_INT32(2);
    kernel_W = PG_GETARG_INT32(3);
    padding_H = PG_GETARG_INT32(4);
    padding_W = PG_GETARG_INT32(5);
    stride = PG_GETARG_INT32(6);
    height = dims[0];
    width = dims[1];
    out_height = (height + 2 * padding_H - kernel_H) / stride + 1;
    out_width = (width + 2 * padding_W - kernel_W) / stride + 1;
    out_nelems = out_height * out_width * num_channel * kernel_W * kernel_H;

    float4 *f_matrix = (float4 *)palloc0(sizeof(float4) * out_nelems);
    int res_idx_local, matrix_head, matrix_head_c;
    omp_set_num_threads(OMP_THREADS);
#pragma omp parallel for collapse(2) private(matrix_head, matrix_head_c, res_idx_local)
    for (int rn = 0; rn < height - kernel_H + 1; rn += stride)
    {
        for (int cn = 0; cn < width - kernel_W + 1; cn += stride)
        {
            res_idx_local = (rn / stride * out_width + cn / stride) * num_channel * kernel_H * kernel_W;
            matrix_head = rn * width + cn;
            for (int c = 0; c < num_channel; c++)
            {
                matrix_head_c = matrix_head + nelems_channel * c;
                for (int ky = 0; ky < kernel_H; ky++)
                {
                    for (int kx = 0; kx < kernel_W; kx++)
                    {
                        f_matrix[res_idx_local++] = input_f[matrix_head_c + width * ky + kx];
                    }
                }
            }
        }
    }

    f_dims[0] = out_width * out_height;
    f_dims[1] = num_channel * kernel_H * kernel_W;

    // kfm
    ArrayType *res;
    int lbound[2] = {1, 1};
    int k_channel, klen, res_rows, res_cols, res_size;

    text *kmatrix_name_text = PG_GETARG_TEXT_PP(0);
    char *kmatrix_name = text_to_cstring(kmatrix_name_text);
    if (WEIGHT_POOL == NULL)
    {
        elog(ERROR, "[conv_text] WEIGHT POOL is NULL");
    }
    WeightEntry *kmatrix_entry = get_weight(WEIGHT_POOL, psprintf("%s_val", kmatrix_name));
    if (kmatrix_entry == NULL)
    {
        elog(ERROR, "[kfm_im2col] %s_val not found", kmatrix_name);
    }
    float4 *k_matrix = (float4 *)kmatrix_entry->data;
    int *kmatrix_dims = kmatrix_entry->dims;
    k_channel = kmatrix_dims[0];
    klen = kmatrix_dims[1];

    if (klen != f_dims[1])
    {
        elog(ERROR, "The number of matrix columns must equal the number of vector elements");
    }

    res_rows = k_channel;
    res_cols = f_dims[0];
    float4 *res_data = (float4 *)palloc(sizeof(float4) * res_rows * res_cols);

    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans,
                res_rows, res_cols, klen,
                1.0, k_matrix, klen, f_matrix, klen,
                0.0, res_data, res_cols);

    WeightEntry *bias_entry = get_weight(WEIGHT_POOL, psprintf("%s_bias", kmatrix_name));
    if (bias_entry == NULL)
    {
        elog(ERROR, "[kfm_im2col] %s_bias not found", kmatrix_name);
    }
    if (bias_entry->dims[0] == k_channel)
    {
        float4 *bias = (float4 *)bias_entry->data;
        int offset = 0;
        for (int c = 0; c < k_channel; c++)
        {
            for (int i = offset; i < offset + res_cols; i++)
            {
                res_data[i] += bias[c];
                res_data[i] = fmax(0, res_data[i]);
            }
            offset += res_cols;
        }
    }

    /* maxpool 1d */
    float4 pool_max;
    Datum *max_res_data = (Datum *)palloc(sizeof(Datum) * res_rows);
    for (int i = 0; i < res_rows; i++)
    {
        matrix_head = i * res_cols;
        pool_max = -INFINITY;
        for (int j = 0; j < res_cols; j++)
        {
            pool_max = fmax(pool_max, res_data[matrix_head + j]);
        }
        max_res_data[i] = Float4GetDatum(pool_max);
    }
    res = construct_array(max_res_data, res_rows, FLOAT4OID, sizeof(float4), true, TYPALIGN_INT);
    PG_RETURN_ARRAYTYPE_P(res);
}