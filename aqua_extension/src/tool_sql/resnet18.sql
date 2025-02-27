WITH
  input_feature_map AS (
	SELECT id, (c.image).array_data AS value
	),
  Conv196_fwd0 AS (
	SELECT id, kfm_im2col('Conv196_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=105.4976438840684) AS value
	FROM input_feature_map I
	),
  MaxPool147_fwd0 AS (
	SELECT id, maxpool(I.value, kernel:=3, padding:=1, stride:=2, op_cost:=4.97630395679568) AS value
	FROM Conv196_fwd0 I
	),
  Conv197_fwd0 AS (
	SELECT id, kfm_im2col('Conv197_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=572.7725854271827) AS value
	FROM MaxPool147_fwd0 I
	),
  Conv150_fwd0 AS (
	SELECT id, kfm_im2col('Conv150_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=572.7725854271827) AS value
	FROM Conv197_fwd0 I
	),
  Add151_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv150_fwd0 I1 INNER JOIN 
	MaxPool147_fwd0 I2 on I1.id=I2.id
	),
  Relu152_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add151_fwd0 I
	),
  Conv198_fwd0 AS (
	SELECT id, kfm_im2col('Conv198_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=572.7725854271827) AS value
	FROM Relu152_fwd0 I
	),
  Conv155_fwd0 AS (
	SELECT id, kfm_im2col('Conv155_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=572.7725854271827) AS value
	FROM Conv198_fwd0 I
	),
  Add156_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv155_fwd0 I1 INNER JOIN 
	Relu152_fwd0 I2 on I1.id=I2.id
	),
  Relu157_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add156_fwd0 I
	),
  Conv159_fwd0 AS (
	SELECT id, kfm_im2col('Conv159_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=31.599530125652564) AS value
	FROM Relu157_fwd0 I
	),
  Conv202_fwd0 AS (
	SELECT id, kfm_im2col('Conv202_weight', I.value, kernel:=3, padding:=1, stride:=2, 
	op_cost:=286.38629271359133) AS value
	FROM Relu157_fwd0 I
	),
  Conv161_fwd0 AS (
	SELECT id, kfm_im2col('Conv161_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.0214006250225) AS value
	FROM Conv202_fwd0 I
	),
  Add162_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv161_fwd0 I1 INNER JOIN 
	Conv159_fwd0 I2 on I1.id=I2.id
	),
  Relu163_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add162_fwd0 I
	),
  Conv199_fwd0 AS (
	SELECT id, kfm_im2col('Conv199_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.0214006250225) AS value
	FROM Relu163_fwd0 I
	),
  Conv166_fwd0 AS (
	SELECT id, kfm_im2col('Conv166_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.0214006250225) AS value
	FROM Conv199_fwd0 I
	),
  Add167_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv166_fwd0 I1 INNER JOIN 
	Relu163_fwd0 I2 on I1.id=I2.id
	),
  Relu168_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add167_fwd0 I
	),
  Conv170_fwd0 AS (
	SELECT id, kfm_im2col('Conv170_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=31.72393772457246) AS value
	FROM Relu168_fwd0 I
	),
  Conv203_fwd0 AS (
	SELECT id, kfm_im2col('Conv203_weight', I.value, kernel:=3, padding:=1, stride:=2, 
	op_cost:=286.51070031251123) AS value
	FROM Relu168_fwd0 I
	),
  Conv172_fwd0 AS (
	SELECT id, kfm_im2col('Conv172_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.1458082239425) AS value
	FROM Conv203_fwd0 I
	),
  Add173_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv172_fwd0 I1 INNER JOIN 
	Conv170_fwd0 I2 on I1.id=I2.id
	),
  Relu174_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add173_fwd0 I
	),
  Conv200_fwd0 AS (
	SELECT id, kfm_im2col('Conv200_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.1458082239425) AS value
	FROM Relu174_fwd0 I
	),
  Conv177_fwd0 AS (
	SELECT id, kfm_im2col('Conv177_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.1458082239425) AS value
	FROM Conv200_fwd0 I
	),
  Add178_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv177_fwd0 I1 INNER JOIN 
	Relu174_fwd0 I2 on I1.id=I2.id
	),
  Relu179_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add178_fwd0 I
	),
  Conv181_fwd0 AS (
	SELECT id, kfm_im2col('Conv181_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=31.786141524032402) AS value
	FROM Relu179_fwd0 I
	),
  Conv204_fwd0 AS (
	SELECT id, kfm_im2col('Conv204_weight', I.value, kernel:=3, padding:=1, stride:=2, 
	op_cost:=286.57290411197124) AS value
	FROM Relu179_fwd0 I
	),
  Conv183_fwd0 AS (
	SELECT id, kfm_im2col('Conv183_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.2080120234023) AS value
	FROM Conv204_fwd0 I
	),
  Add184_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv183_fwd0 I1 INNER JOIN 
	Conv181_fwd0 I2 on I1.id=I2.id
	),
  Relu185_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add184_fwd0 I
	),
  Conv201_fwd0 AS (
	SELECT id, kfm_im2col('Conv201_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.2080120234023) AS value
	FROM Relu185_fwd0 I
	),
  Conv188_fwd0 AS (
	SELECT id, kfm_im2col('Conv188_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=573.2080120234023) AS value
	FROM Conv201_fwd0 I
	),
  Add189_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv188_fwd0 I1 INNER JOIN 
	Relu185_fwd0 I2 on I1.id=I2.id
	),
  Relu190_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add189_fwd0 I
	),
  AveragePool192_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=2, padding:=0, stride:=2, op_cost:=0.0777547493249325) AS value
	FROM Relu190_fwd0 I
	),
  Reshape193_fwd0 AS (
	SELECT id, array_agg(t.value) as value
	FROM (SELECT id, unnest(I.value) as value FROM AveragePool192_fwd0 I) AS t
	GROUP BY id
	),
  MatMul195_fwd0 AS (
	SELECT id, mvm('Transpose194_input', I.value, op_cost:=0.31071526781017944) AS value
	FROM Reshape193_fwd0 I
	)
SELECT l.name AS res FROM
cifar10_labels l
JOIN (
	SELECT argmax(value) AS label FROM MatMul195_fwd0) t
	ON t.label = l.label