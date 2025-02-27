--rating
WITH
  input_feature_map AS (
	SELECT id, reviews_text AS value
	from amazon),
  rating_conv_0 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_0_weight W
    ),
  rating_conv_1 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_1_weight W
    ),
  rating_conv_2 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_2_weight W
    ),
  rating_concat_0 as(
    select I1.id, array_cat(array_cat(I1.value, I2.value), I3.value) as value
    FROM rating_conv_0 I1
        INNER JOIN rating_conv_1 I2 on I1.id=I2.id
        INNER JOIN rating_conv_2 I3 on I1.id=I3.id
    ),
  rating_matmul_0 AS (
	SELECT id, mvm(W.val, I.value, W.bias) AS value
	FROM rating_concat_0 I, rating_fc_weight W
	)
SELECT id, argmax(value)-1 AS label FROM rating_matmul_0;

--spam
WITH
  input_feature_map AS (
	SELECT id, reviews_text AS value
	from amazon),
  spam_conv_0 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_0_weight W
    ),
  spam_conv_1 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_1_weight W
    ),
  spam_conv_2 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_2_weight W
    ),
  spam_concat_0 as(
    select I1.id, array_cat(array_cat(I1.value, I2.value), I3.value) as value
    FROM spam_conv_0 I1
        INNER JOIN spam_conv_1 I2 on I1.id=I2.id
        INNER JOIN spam_conv_2 I3 on I1.id=I3.id
    ),
  spam_matmul_0 AS (
	SELECT id, mvm(W.val, I.value, W.bias) AS value
	FROM spam_concat_0 I, spam_fc_weight W
	)
SELECT id, argmax(value)-1 AS label FROM spam_matmul_0;


select id, rating(reviews_text) from amazon;
CREATE OR REPLACE FUNCTION rating(input real[])
RETURNS text
AS $$
      import numpy as np 
      import onnx
      from onnx import shape_inference
      import onnxruntime as rt
      import plpy
       
      model_path = "/home/pyc/workspace/DBOCG/models/rating_textcnn.onnx"
      np_input = np.array(input, dtype=np.float32)
      np_input = np_input.reshape(1, 128, 96)

      sess_options = rt.SessionOptions()
      # sess_options.inter_op_num_threads = 1
      sess_options.intra_op_num_threads = 8
      sess_options.graph_optimization_level = rt.GraphOptimizationLevel.ORT_DISABLE_ALL

      sess = rt.InferenceSession(model_path, sess_options)
      output = sess.run(None, {
      "input": np_input
      })
      # plpy.info("[pycolor] executing...")
      predicted_class = np.argmax(output[0], axis=1)[0]
      return predicted_class
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select id, spam(reviews_text) from amazon;
CREATE OR REPLACE FUNCTION spam(input real[])
RETURNS text
AS $$
      import numpy as np 
      import onnx
      from onnx import shape_inference
      import onnxruntime as rt
      import plpy
       
      model_path = "/home/pyc/workspace/DBOCG/models/spam_textcnn.onnx"
      np_input = np.array(input, dtype=np.float32)
      np_input = np_input.reshape(1, 128, 96)

      sess_options = rt.SessionOptions()
      # sess_options.inter_op_num_threads = 1
      sess_options.intra_op_num_threads = 8
      sess_options.graph_optimization_level = rt.GraphOptimizationLevel.ORT_DISABLE_ALL

      sess = rt.InferenceSession(model_path, sess_options)
      output = sess.run(None, {
      "input": np_input
      })
      # plpy.info("[pycolor] executing...")
      predicted_class = np.argmax(output[0], axis=1)[0]
      return predicted_class
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select count(id), rating(reviews_text) score, spam(reviews_text) s 
from amazon 
group by score, s




select count(id),
(WITH
  input_feature_map AS (
	SELECT id, reviews_text AS value
	),
  rating_conv_0 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_0_weight W
    ),
  rating_conv_1 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_1_weight W
    ),
  rating_conv_2 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, rating_conv_2_weight W
    ),
  rating_concat_0 as(
    select I1.id, array_cat(array_cat(I1.value, I2.value), I3.value) as value
    FROM rating_conv_0 I1
        INNER JOIN rating_conv_1 I2 on I1.id=I2.id
        INNER JOIN rating_conv_2 I3 on I1.id=I3.id
    ),
  rating_matmul_0 AS (
	SELECT id, mvm(W.val, I.value, W.bias) AS value
	FROM rating_concat_0 I, rating_fc_weight W
	)
SELECT argmax(value)-1 FROM rating_matmul_0
) rating,
(WITH
  input_feature_map AS (
	SELECT id, reviews_text AS value
	),
  spam_conv_0 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_0_weight W
    ),
  spam_conv_1 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_1_weight W
    ),
  spam_conv_2 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, spam_conv_2_weight W
    ),
  spam_concat_0 as(
    select I1.id, array_cat(array_cat(I1.value, I2.value), I3.value) as value
    FROM spam_conv_0 I1
        INNER JOIN spam_conv_1 I2 on I1.id=I2.id
        INNER JOIN spam_conv_2 I3 on I1.id=I3.id
    ),
  spam_matmul_0 AS (
	SELECT id, mvm(W.val, I.value, W.bias) AS value
	FROM spam_concat_0 I, spam_fc_weight W
	)
SELECT argmax(value)-1 FROM spam_matmul_0
) spam from amazon group by rating, spam;


select count(id),
(WITH
  input_feature_map AS (
	SELECT id, reviews_text AS value
	),
  conv_0 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, conv_0_weight W
    ),
  conv_1 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, conv_1_weight W
    ),
  conv_2 as(
    SELECT id, conv_text(
		W.val, I.value, W.bias, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I, conv_2_weight W
    ),
  concat_0 as(
    select I1.id, array_cat(array_cat(I1.value[1:100], I2.value[1:100]), I3.value[1:100]) as value1,
    array_cat(array_cat(I1.value[101:200], I2.value[101:200]), I3.value[101:200]) as value2
    FROM conv_0 I1
        INNER JOIN conv_1 I2 on I1.id=I2.id
        INNER JOIN conv_2 I3 on I1.id=I3.id
    ), 
  matmul_0 AS (
	SELECT id, mvm(W1.val, I.value1, W1.bias) AS value1, mvm(W2.val, I.value2, W2.bias) AS value2
	FROM concat_0 I, rating_fc_weight W1, spam_fc_weight W2
	) 
  SELECT argmax(value1)*10+argmax(value2) as value FROM matmul_0 
) label from amazon group by label;


select id, rating(reviews_text) from amazon;
CREATE OR REPLACE FUNCTION rating(input real[])
RETURNS text
AS $$
      import requests
      import json
      import plpy
      import numpy as np
      
       
      url = 'http://127.0.0.1:8000/predict/'  
      # 准备请求数据  
      headers = {'Content-Type': 'application/json'}  
      data = json.dumps({"input": input})         
      response = requests.post(url, headers=headers, data=data)  
      result = response.json() 
      output = result['output'] 
      # predicted_class = result['output']
      # plpy.info(f"[pycolor] output:{output}")
      predicted_class = np.argmax(np.array(output))
      return predicted_class
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

CREATE OR REPLACE FUNCTION spam(input real[])
RETURNS text
AS $$
      import requests
      import json
      import plpy
      import numpy as np
      
       
      url = 'http://127.0.0.1:8000/predict/'  
      # 准备请求数据  
      headers = {'Content-Type': 'application/json'}  
      data = json.dumps({"input": input})         
      response = requests.post(url, headers=headers, data=data)  
      result = response.json() 
      output = result['output'] 
      # predicted_class = result['output']
      # plpy.info(f"[pycolor] output:{output}")
      predicted_class = np.argmax(np.array(output))
      return predicted_class
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select count(id), rating(reviews_text) score, spam(reviews_text) s 
from amazon 
group by score, s