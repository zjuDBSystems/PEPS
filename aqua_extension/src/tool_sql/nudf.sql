WITH
  input_feature_map AS (
	SELECT id, im2col_init(c.image) AS value
	from cifar c
	),
  Conv165_fwd0 AS (
	SELECT id, kfm(W.val, I.value) AS value
	FROM input_feature_map I, Conv165_weight W
	),
  Relu169_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv165_fwd0 I
	),
  Conv170_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu169_fwd0 I, Conv170_weight W
	),
  Conv173_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu169_fwd0 I, Conv173_weight W
	),
  Relu176_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv170_fwd0 I
	),
  Conv2D_177_split AS (
	SELECT id, S.gn, S.value
	FROM Relu176_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv177_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_177_split I join Conv177_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu180_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv177_fwd0 I
	),
  Conv181_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu180_fwd0 I, Conv181_weight W
	),
  Add184_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv173_fwd0 I1
	INNER JOIN Conv181_fwd0 I2 on I1.id=I2.id
	),
  Relu185_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add184_fwd0 I
	),
  Conv186_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu185_fwd0 I, Conv186_weight W
	),
  Relu189_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv186_fwd0 I
	),
  Conv2D_190_split AS (
	SELECT id, S.gn, S.value
	FROM Relu189_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv190_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_190_split I join Conv190_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu193_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv190_fwd0 I
	),
  Conv194_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu193_fwd0 I, Conv194_weight W
	),
  Add197_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu185_fwd0 I1
	INNER JOIN Conv194_fwd0 I2 on I1.id=I2.id
	),
  Relu198_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add197_fwd0 I
	),
  Conv199_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu198_fwd0 I, Conv199_weight W
	),
  Relu202_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv199_fwd0 I
	),
  Conv2D_203_split AS (
	SELECT id, S.gn, S.value
	FROM Relu202_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv203_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_203_split I join Conv203_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu206_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv203_fwd0 I
	),
  Conv207_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu206_fwd0 I, Conv207_weight W
	),
  Add210_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu198_fwd0 I1
	INNER JOIN Conv207_fwd0 I2 on I1.id=I2.id
	),
  Relu211_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add210_fwd0 I
	),
  Conv212_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu211_fwd0 I, Conv212_weight W
	),
  Conv215_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=2)) AS value
	FROM Relu211_fwd0 I, Conv215_weight W
	),
  Relu218_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv212_fwd0 I
	),
  Conv2D_219_split AS (
	SELECT id, S.gn, S.value
	FROM Relu218_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv219_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=2))) AS value
	FROM Conv2D_219_split I join Conv219_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu222_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv219_fwd0 I
	),
  Conv223_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu222_fwd0 I, Conv223_weight W
	),
  Add226_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv215_fwd0 I1
	INNER JOIN Conv223_fwd0 I2 on I1.id=I2.id
	),
  Relu227_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add226_fwd0 I
	),
  Conv228_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu227_fwd0 I, Conv228_weight W
	),
  Relu231_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv228_fwd0 I
	),
  Conv2D_232_split AS (
	SELECT id, S.gn, S.value
	FROM Relu231_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv232_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_232_split I join Conv232_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu235_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv232_fwd0 I
	),
  Conv236_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu235_fwd0 I, Conv236_weight W
	),
  Add239_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu227_fwd0 I1
	INNER JOIN Conv236_fwd0 I2 on I1.id=I2.id
	),
  Relu240_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add239_fwd0 I
	),
  Conv241_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu240_fwd0 I, Conv241_weight W
	),
  Relu244_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv241_fwd0 I
	),
  Conv2D_245_split AS (
	SELECT id, S.gn, S.value
	FROM Relu244_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv245_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_245_split I join Conv245_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu248_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv245_fwd0 I
	),
  Conv249_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu248_fwd0 I, Conv249_weight W
	),
  Add252_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu240_fwd0 I1
	INNER JOIN Conv249_fwd0 I2 on I1.id=I2.id
	),
  Relu253_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add252_fwd0 I
	),
  Conv254_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu253_fwd0 I, Conv254_weight W
	),
  Conv257_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=2)) AS value
	FROM Relu253_fwd0 I, Conv257_weight W
	),
  Relu260_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv254_fwd0 I
	),
  Conv2D_261_split AS (
	SELECT id, S.gn, S.value
	FROM Relu260_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv261_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=2))) AS value
	FROM Conv2D_261_split I join Conv261_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu264_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv261_fwd0 I
	),
  Conv265_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu264_fwd0 I, Conv265_weight W
	),
  Add268_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Conv257_fwd0 I1
	INNER JOIN Conv265_fwd0 I2 on I1.id=I2.id
	),
  Relu269_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add268_fwd0 I
	),
  Conv270_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu269_fwd0 I, Conv270_weight W
	),
  Relu273_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv270_fwd0 I
	),
  Conv2D_274_split AS (
	SELECT id, S.gn, S.value
	FROM Relu273_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv274_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_274_split I join Conv274_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu277_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv274_fwd0 I
	),
  Conv278_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu277_fwd0 I, Conv278_weight W
	),
  Add281_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu269_fwd0 I1
	INNER JOIN Conv278_fwd0 I2 on I1.id=I2.id
	),
  Relu282_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add281_fwd0 I
	),
  Conv283_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu282_fwd0 I, Conv283_weight W
	),
  Relu286_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv283_fwd0 I
	),
  Conv2D_287_split AS (
	SELECT id, S.gn, S.value
	FROM Relu286_fwd0 I,
	LATERAL split_array(I.value, 8)
		AS S(gn, value) 
	),
  Conv287_fwd0 AS (
	SELECT id, array_2d_agg(
	kfm(W.val, im2col(I.value, kernel:=3, padding:=1, stride:=1))) AS value
	FROM Conv2D_287_split I join Conv287_weight W
	on I.gn = W.gn GROUP BY id
	),
  Relu290_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv287_fwd0 I
	),
  Conv291_fwd0 AS (
	SELECT id, kfm(W.val, im2col(I.value, kernel:=1, padding:=0, stride:=1)) AS value
	FROM Relu290_fwd0 I, Conv291_weight W
	),
  Add294_fwd0 AS (
	SELECT I1.id, madd(I1.value, I2.value) AS value
	FROM Relu282_fwd0 I1
	INNER JOIN Conv291_fwd0 I2 on I1.id=I2.id
	),
  Relu295_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Add294_fwd0 I
	),
  AveragePool297_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=8) AS value
	FROM Relu295_fwd0 I
	),
  Reshape298_fwd0 AS (
	SELECT id, array_agg(t.value) as value
	FROM (SELECT id, unnest(I.value) as value FROM AveragePool297_fwd0 I) AS t
	GROUP BY id
	),
  MatMul300_fwd0 AS (
	SELECT id, mvm(W.val, I.value) AS value
	FROM Reshape298_fwd0 I, Transpose299_input W
	)
SELECT l.name AS res FROM
cifar10_labels l
JOIN (
	SELECT argmax(value) AS label FROM MatMul300_fwd0) t
	ON t.label = l.label