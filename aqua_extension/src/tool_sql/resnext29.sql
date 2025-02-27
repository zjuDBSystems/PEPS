WITH
  input_feature_map AS (
	SELECT id, (c.image).array_data AS value from cifar c
	),
  Conv241_fwd0 AS (
	SELECT id, kfm_im2col('Conv241_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=105.4976438840684) AS value
	FROM input_feature_map I
	),
  MaxPool169_fwd0 AS (
	SELECT id, maxpool(I.value, kernel:=3, padding:=1, stride:=2, op_cost:=4.97630395679568) AS value
	FROM Conv241_fwd0 I
	),
  Conv171_fwd0 AS (
	SELECT id, kfm_nt('Conv171_weight', I.value) AS value
	FROM MaxPool169_fwd0 I
	),
  Conv242_fwd0 AS (
	SELECT id, kfm_nt('Conv242_weight', I.value, acti:=true) AS value
	FROM MaxPool169_fwd0 I
	),
  Conv243_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv243_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv242_fwd0 I
	),
  Conv175_fwd0 AS (
	SELECT id, kfm_nt('Conv175_weight', I.value) AS value
	FROM Conv243_fwd0 I
	),
  Add176_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv171_fwd0 I1 INNER JOIN 
	Conv175_fwd0 I2 on I1.id=I2.id
	),
  Relu177_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add176_fwd0 I
	),
  Conv244_fwd0 AS (
	SELECT id, kfm_nt('Conv244_weight', I.value, acti:=true) AS value
	FROM Relu177_fwd0 I
	),
  Conv245_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv245_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv244_fwd0 I
	),
  Conv182_fwd0 AS (
	SELECT id, kfm_nt('Conv182_weight', I.value) AS value
	FROM Conv245_fwd0 I
	),
  Add183_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu177_fwd0 I1 INNER JOIN 
	Conv182_fwd0 I2 on I1.id=I2.id
	),
  Relu184_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add183_fwd0 I
	),
  Conv246_fwd0 AS (
	SELECT id, kfm_nt('Conv246_weight', I.value, acti:=true) AS value
	FROM Relu184_fwd0 I
	),
  Conv247_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv247_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv246_fwd0 I
	),
  Conv189_fwd0 AS (
	SELECT id, kfm_nt('Conv189_weight', I.value) AS value
	FROM Conv247_fwd0 I
	),
  Add190_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu184_fwd0 I1 INNER JOIN 
	Conv189_fwd0 I2 on I1.id=I2.id
	),
  Relu191_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add190_fwd0 I
	),
  Conv193_fwd0 AS (
	SELECT id, kfm_im2col('Conv193_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=508.57826438451843) AS value
	FROM Relu191_fwd0 I
	),
  Conv248_fwd0 AS (
	SELECT id, kfm_nt('Conv248_weight', I.value, acti:=true) AS value
	FROM Relu191_fwd0 I
	),
  Conv258_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv258_weight', I.value, kernel:=3, padding:=1, stride:=2, groups:=32) AS value
	FROM Conv248_fwd0 I
	),
  Conv197_fwd0 AS (
	SELECT id, kfm_nt('Conv197_weight', I.value) AS value
	FROM Conv258_fwd0 I
	),
  Add198_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv193_fwd0 I1 INNER JOIN 
	Conv197_fwd0 I2 on I1.id=I2.id
	),
  Relu199_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add198_fwd0 I
	),
  Conv249_fwd0 AS (
	SELECT id, kfm_nt('Conv249_weight', I.value, acti:=true) AS value
	FROM Relu199_fwd0 I
	),
  Conv250_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv250_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv249_fwd0 I
	),
  Conv204_fwd0 AS (
	SELECT id, kfm_nt('Conv204_weight', I.value) AS value
	FROM Conv250_fwd0 I
	),
  Add205_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu199_fwd0 I1 INNER JOIN 
	Conv204_fwd0 I2 on I1.id=I2.id
	),
  Relu206_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add205_fwd0 I
	),
  Conv251_fwd0 AS (
	SELECT id, kfm_nt('Conv251_weight', I.value, acti:=true) AS value
	FROM Relu206_fwd0 I
	),
  Conv252_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv252_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv251_fwd0 I
	),
  Conv211_fwd0 AS (
	SELECT id, kfm_nt('Conv211_weight', I.value) AS value
	FROM Conv252_fwd0 I
	),
  Add212_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu206_fwd0 I1 INNER JOIN 
	Conv211_fwd0 I2 on I1.id=I2.id
	),
  Relu213_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add212_fwd0 I
	),
  Conv215_fwd0 AS (
	SELECT id, kfm_im2col('Conv215_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=509.075894780198) AS value
	FROM Relu213_fwd0 I
	),
  Conv253_fwd0 AS (
	SELECT id, kfm_nt('Conv253_weight', I.value, acti:=true) AS value
	FROM Relu213_fwd0 I
	),
  Conv259_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv259_weight', I.value, kernel:=3, padding:=1, stride:=2, groups:=32) AS value
	FROM Conv253_fwd0 I
	),
  Conv219_fwd0 AS (
	SELECT id, kfm_nt('Conv219_weight', I.value) AS value
	FROM Conv259_fwd0 I
	),
  Add220_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv215_fwd0 I1 INNER JOIN 
	Conv219_fwd0 I2 on I1.id=I2.id
	),
  Relu221_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add220_fwd0 I
	),
  Conv254_fwd0 AS (
	SELECT id, kfm_nt('Conv254_weight', I.value, acti:=true) AS value
	FROM Relu221_fwd0 I
	),
  Conv255_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv255_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv254_fwd0 I
	),
  Conv226_fwd0 AS (
	SELECT id, kfm_nt('Conv226_weight', I.value) AS value
	FROM Conv255_fwd0 I
	),
  Add227_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu221_fwd0 I1 INNER JOIN 
	Conv226_fwd0 I2 on I1.id=I2.id
	),
  Relu228_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add227_fwd0 I
	),
  Conv256_fwd0 AS (
	SELECT id, kfm_nt('Conv256_weight', I.value, acti:=true) AS value
	FROM Relu228_fwd0 I
	),
  Conv257_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv257_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv256_fwd0 I
	),
  Conv233_fwd0 AS (
	SELECT id, kfm_nt('Conv233_weight', I.value) AS value
	FROM Conv257_fwd0 I
	),
  Add234_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu228_fwd0 I1 INNER JOIN 
	Conv233_fwd0 I2 on I1.id=I2.id
	),
  Relu235_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add234_fwd0 I
	),
  AveragePool237_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=4, padding:=0, stride:=4, op_cost:=0.5287322954095409) AS value
	FROM Relu235_fwd0 I
	),
  Reshape238_fwd0 AS (
	SELECT id, array_agg(t.value) as value
	FROM (SELECT id, unnest(I.value) as value FROM AveragePool237_fwd0 I) AS t
	GROUP BY id
	),
  MatMul240_fwd0 AS (
	SELECT id, mvm('Transpose239_input', I.value, op_cost:=0.6217342651099094) AS value
	FROM Reshape238_fwd0 I
	)
SELECT l.name AS res FROM
cifar10_labels l
JOIN (
	SELECT argmax(value) AS label FROM MatMul240_fwd0) t
	ON t.label = l.label