WITH
  input_feature_map AS (
	SELECT id, (c.image).array_data AS value
	from cifar c
	),
  Conv319_fwd0 AS (
	SELECT id, kfm_im2col('Conv319_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=105.4976438840684) AS value
	FROM input_feature_map I
	),
  MaxPool205_fwd0 AS (
	SELECT id, maxpool(I.value, kernel:=3, padding:=1, stride:=2, op_cost:=4.97630395679568) AS value
	FROM Conv319_fwd0 I
	),
  Conv207_fwd0 AS (
	SELECT id, kfm_nt('Conv207_weight', I.value) AS value
	FROM MaxPool205_fwd0 I
	),
  Conv320_fwd0 AS (
	SELECT id, kfm_nt('Conv320_weight', I.value, acti:=true) AS value
	FROM MaxPool205_fwd0 I
	),
  Conv321_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv321_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv320_fwd0 I
	),
  Conv211_fwd0 AS (
	SELECT id, kfm_nt('Conv211_weight', I.value) AS value
	FROM Conv321_fwd0 I
	),
  Add212_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv207_fwd0 I1 INNER JOIN 
	Conv211_fwd0 I2 on I1.id=I2.id
	),
  Relu213_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add212_fwd0 I
	),
  Conv322_fwd0 AS (
	SELECT id, kfm_nt('Conv322_weight', I.value, acti:=true) AS value
	FROM Relu213_fwd0 I
	),
  Conv323_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv323_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv322_fwd0 I
	),
  Conv218_fwd0 AS (
	SELECT id, kfm_nt('Conv218_weight', I.value) AS value
	FROM Conv323_fwd0 I
	),
  Add219_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu213_fwd0 I1 INNER JOIN 
	Conv218_fwd0 I2 on I1.id=I2.id
	),
  Relu220_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add219_fwd0 I
	),
  Conv324_fwd0 AS (
	SELECT id, kfm_nt('Conv324_weight', I.value, acti:=true) AS value
	FROM Relu220_fwd0 I
	),
  Conv325_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv325_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv324_fwd0 I
	),
  Conv225_fwd0 AS (
	SELECT id, kfm_nt('Conv225_weight', I.value) AS value
	FROM Conv325_fwd0 I
	),
  Add226_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu220_fwd0 I1 INNER JOIN 
	Conv225_fwd0 I2 on I1.id=I2.id
	),
  Relu227_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add226_fwd0 I
	),
  Conv326_fwd0 AS (
	SELECT id, kfm_nt('Conv326_weight', I.value, acti:=true) AS value
	FROM Relu227_fwd0 I
	),
  Conv327_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv327_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv326_fwd0 I
	),
  Conv232_fwd0 AS (
	SELECT id, kfm_nt('Conv232_weight', I.value) AS value
	FROM Conv327_fwd0 I
	),
  Add233_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu227_fwd0 I1 INNER JOIN 
	Conv232_fwd0 I2 on I1.id=I2.id
	),
  Relu234_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add233_fwd0 I
	),
  Conv328_fwd0 AS (
	SELECT id, kfm_nt('Conv328_weight', I.value, acti:=true) AS value
	FROM Relu234_fwd0 I
	),
  Conv329_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv329_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv328_fwd0 I
	),
  Conv239_fwd0 AS (
	SELECT id, kfm_nt('Conv239_weight', I.value) AS value
	FROM Conv329_fwd0 I
	),
  Add240_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu234_fwd0 I1 INNER JOIN 
	Conv239_fwd0 I2 on I1.id=I2.id
	),
  Relu241_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add240_fwd0 I
	),
  Conv243_fwd0 AS (
	SELECT id, kfm_im2col('Conv243_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=508.57826438451843) AS value
	FROM Relu241_fwd0 I
	),
  Conv330_fwd0 AS (
	SELECT id, kfm_nt('Conv330_weight', I.value, acti:=true) AS value
	FROM Relu241_fwd0 I
	),
  Conv348_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv348_weight', I.value, kernel:=3, padding:=1, stride:=2, groups:=32) AS value
	FROM Conv330_fwd0 I
	),
  Conv247_fwd0 AS (
	SELECT id, kfm_nt('Conv247_weight', I.value) AS value
	FROM Conv348_fwd0 I
	),
  Add248_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv243_fwd0 I1 INNER JOIN 
	Conv247_fwd0 I2 on I1.id=I2.id
	),
  Relu249_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add248_fwd0 I
	),
  Conv331_fwd0 AS (
	SELECT id, kfm_nt('Conv331_weight', I.value, acti:=true) AS value
	FROM Relu249_fwd0 I
	),
  Conv332_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv332_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv331_fwd0 I
	),
  Conv254_fwd0 AS (
	SELECT id, kfm_nt('Conv254_weight', I.value) AS value
	FROM Conv332_fwd0 I
	),
  Add255_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu249_fwd0 I1 INNER JOIN 
	Conv254_fwd0 I2 on I1.id=I2.id
	),
  Relu256_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add255_fwd0 I
	),
  Conv333_fwd0 AS (
	SELECT id, kfm_nt('Conv333_weight', I.value, acti:=true) AS value
	FROM Relu256_fwd0 I
	),
  Conv334_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv334_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv333_fwd0 I
	),
  Conv261_fwd0 AS (
	SELECT id, kfm_nt('Conv261_weight', I.value) AS value
	FROM Conv334_fwd0 I
	),
  Add262_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu256_fwd0 I1 INNER JOIN 
	Conv261_fwd0 I2 on I1.id=I2.id
	),
  Relu263_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add262_fwd0 I
	),
  Conv335_fwd0 AS (
	SELECT id, kfm_nt('Conv335_weight', I.value, acti:=true) AS value
	FROM Relu263_fwd0 I
	),
  Conv336_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv336_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv335_fwd0 I
	),
  Conv268_fwd0 AS (
	SELECT id, kfm_nt('Conv268_weight', I.value) AS value
	FROM Conv336_fwd0 I
	),
  Add269_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu263_fwd0 I1 INNER JOIN 
	Conv268_fwd0 I2 on I1.id=I2.id
	),
  Relu270_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add269_fwd0 I
	),
  Conv337_fwd0 AS (
	SELECT id, kfm_nt('Conv337_weight', I.value, acti:=true) AS value
	FROM Relu270_fwd0 I
	),
  Conv338_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv338_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv337_fwd0 I
	),
  Conv275_fwd0 AS (
	SELECT id, kfm_nt('Conv275_weight', I.value) AS value
	FROM Conv338_fwd0 I
	),
  Add276_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu270_fwd0 I1 INNER JOIN 
	Conv275_fwd0 I2 on I1.id=I2.id
	),
  Relu277_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add276_fwd0 I
	),
  Conv279_fwd0 AS (
	SELECT id, kfm_im2col('Conv279_weight', I.value, kernel:=1, padding:=0, stride:=2, 
	op_cost:=509.075894780198) AS value
	FROM Relu277_fwd0 I
	),
  Conv339_fwd0 AS (
	SELECT id, kfm_nt('Conv339_weight', I.value, acti:=true) AS value
	FROM Relu277_fwd0 I
	),
  Conv349_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv349_weight', I.value, kernel:=3, padding:=1, stride:=2, groups:=32) AS value
	FROM Conv339_fwd0 I
	),
  Conv283_fwd0 AS (
	SELECT id, kfm_nt('Conv283_weight', I.value) AS value
	FROM Conv349_fwd0 I
	),
  Add284_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv279_fwd0 I1 INNER JOIN 
	Conv283_fwd0 I2 on I1.id=I2.id
	),
  Relu285_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add284_fwd0 I
	),
  Conv340_fwd0 AS (
	SELECT id, kfm_nt('Conv340_weight', I.value, acti:=true) AS value
	FROM Relu285_fwd0 I
	),
  Conv341_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv341_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv340_fwd0 I
	),
  Conv290_fwd0 AS (
	SELECT id, kfm_nt('Conv290_weight', I.value) AS value
	FROM Conv341_fwd0 I
	),
  Add291_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu285_fwd0 I1 INNER JOIN 
	Conv290_fwd0 I2 on I1.id=I2.id
	),
  Relu292_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add291_fwd0 I
	),
  Conv342_fwd0 AS (
	SELECT id, kfm_nt('Conv342_weight', I.value, acti:=true) AS value
	FROM Relu292_fwd0 I
	),
  Conv343_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv343_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv342_fwd0 I
	),
  Conv297_fwd0 AS (
	SELECT id, kfm_nt('Conv297_weight', I.value) AS value
	FROM Conv343_fwd0 I
	),
  Add298_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu292_fwd0 I1 INNER JOIN 
	Conv297_fwd0 I2 on I1.id=I2.id
	),
  Relu299_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add298_fwd0 I
	),
  Conv344_fwd0 AS (
	SELECT id, kfm_nt('Conv344_weight', I.value, acti:=true) AS value
	FROM Relu299_fwd0 I
	),
  Conv345_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv345_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv344_fwd0 I
	),
  Conv304_fwd0 AS (
	SELECT id, kfm_nt('Conv304_weight', I.value) AS value
	FROM Conv345_fwd0 I
	),
  Add305_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu299_fwd0 I1 INNER JOIN 
	Conv304_fwd0 I2 on I1.id=I2.id
	),
  Relu306_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add305_fwd0 I
	),
  Conv346_fwd0 AS (
	SELECT id, kfm_nt('Conv346_weight', I.value, acti:=true) AS value
	FROM Relu306_fwd0 I
	),
  Conv347_fwd0 AS (
	SELECT id, 
	group_kfm_im2col('Conv347_weight', I.value, kernel:=3, padding:=1, stride:=1, groups:=32) AS value
	FROM Conv346_fwd0 I
	),
  Conv311_fwd0 AS (
	SELECT id, kfm_nt('Conv311_weight', I.value) AS value
	FROM Conv347_fwd0 I
	),
  Add312_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu306_fwd0 I1 INNER JOIN 
	Conv311_fwd0 I2 on I1.id=I2.id
	),
  Relu313_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add312_fwd0 I
	),
  AveragePool315_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=4, padding:=0, stride:=4, op_cost:=0.5287322954095409) AS value
	FROM Relu313_fwd0 I
	),
  Reshape316_fwd0 AS (
	SELECT id, array_agg(t.value) as value
	FROM (SELECT id, unnest(I.value) as value FROM AveragePool315_fwd0 I) AS t
	GROUP BY id
	),
  MatMul318_fwd0 AS (
	SELECT id, mvm('Transpose317_input', I.value, op_cost:=0.6217342651099094) AS value
	FROM Reshape316_fwd0 I
	)
SELECT l.name AS res FROM
cifar10_labels l
JOIN (
	SELECT argmax(value) AS label FROM MatMul318_fwd0) t
	ON t.label = l.label