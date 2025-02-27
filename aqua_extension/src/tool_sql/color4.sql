WITH
  input_feature_map AS (
	SELECT id, (c.image).array_data AS value from cifar c
	),
  Conv283_fwd0 AS (
	SELECT id, kfm_im2col('Conv283_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=316.4929316522052) AS value
	FROM input_feature_map I
	),
  Relu285_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv283_fwd0 I
	),
  Conv286_fwd0 AS (
	SELECT id, kfm_nt('Conv286_weight', I.value) AS value
	FROM Relu285_fwd0 I
	),
  Conv287_fwd0 AS (
	SELECT id, kfm_nt('Conv287_weight', I.value) AS value
	FROM Relu285_fwd0 I
	),
  Conv288_fwd0 AS (
	SELECT id, kfm_nt('Conv288_weight', I.value) AS value
	FROM Relu285_fwd0 I
	),
  AveragePool293_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=59.71564748154815) AS value
	FROM Relu285_fwd0 I
	),
  Relu289_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv286_fwd0 I
	),
  Relu290_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv287_fwd0 I
	),
  Relu291_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv288_fwd0 I
	),
  Conv296_fwd0 AS (
	SELECT id, kfm_nt('Conv296_weight', I.value) AS value
	FROM AveragePool293_fwd0 I
	),
  Conv294_fwd0 AS (
	SELECT id, kfm_im2col('Conv294_weight', I.value, kernel:=5, padding:=2, stride:=1, 
	op_cost:=4775.261276941134) AS value
	FROM Relu290_fwd0 I
	),
  Conv295_fwd0 AS (
	SELECT id, kfm_im2col('Conv295_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=3436.635512563096) AS value
	FROM Relu291_fwd0 I
	),
  Relu299_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv296_fwd0 I
	),
  Relu297_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv294_fwd0 I
	),
  Relu298_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv295_fwd0 I
	),
  Conv300_fwd0 AS (
	SELECT id, kfm_im2col('Conv300_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=5156.446160031684) AS value
	FROM Relu298_fwd0 I
	),
  Relu301_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv300_fwd0 I
	),
  Concat302_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu289_fwd0 I1 
	INNER JOIN Relu297_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu301_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu299_fwd0 I4 on I1.id=I4.id
	),
  Conv303_fwd0 AS (
	SELECT id, kfm_nt('Conv303_weight', I.value) AS value
	FROM Concat302_fwd0 I
	),
  Conv304_fwd0 AS (
	SELECT id, kfm_nt('Conv304_weight', I.value) AS value
	FROM Concat302_fwd0 I
	),
  Conv305_fwd0 AS (
	SELECT id, kfm_nt('Conv305_weight', I.value) AS value
	FROM Concat302_fwd0 I
	),
  AveragePool310_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=79.62086330873088) AS value
	FROM Concat302_fwd0 I
	),
  Relu306_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv303_fwd0 I
	),
  Relu307_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv304_fwd0 I
	),
  Relu308_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv305_fwd0 I
	),
  Conv313_fwd0 AS (
	SELECT id, kfm_nt('Conv313_weight', I.value) AS value
	FROM AveragePool310_fwd0 I
	),
  Conv311_fwd0 AS (
	SELECT id, kfm_im2col('Conv311_weight', I.value, kernel:=5, padding:=2, stride:=1, 
	op_cost:=4775.261276941134) AS value
	FROM Relu307_fwd0 I
	),
  Conv312_fwd0 AS (
	SELECT id, kfm_im2col('Conv312_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=3436.635512563096) AS value
	FROM Relu308_fwd0 I
	),
  Relu316_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv313_fwd0 I
	),
  Relu314_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv311_fwd0 I
	),
  Relu315_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv312_fwd0 I
	),
  Conv317_fwd0 AS (
	SELECT id, kfm_im2col('Conv317_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=5156.446160031684) AS value
	FROM Relu315_fwd0 I
	),
  Relu318_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv317_fwd0 I
	),
  Concat319_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu306_fwd0 I1 
	INNER JOIN Relu314_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu318_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu316_fwd0 I4 on I1.id=I4.id
	),
  Conv320_fwd0 AS (
	SELECT id, kfm_nt('Conv320_weight', I.value) AS value
	FROM Concat319_fwd0 I
	),
  Conv321_fwd0 AS (
	SELECT id, kfm_nt('Conv321_weight', I.value) AS value
	FROM Concat319_fwd0 I
	),
  Conv322_fwd0 AS (
	SELECT id, kfm_nt('Conv322_weight', I.value) AS value
	FROM Concat319_fwd0 I
	),
  AveragePool327_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=89.57347122232223) AS value
	FROM Concat319_fwd0 I
	),
  Relu323_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv320_fwd0 I
	),
  Relu324_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv321_fwd0 I
	),
  Relu325_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv322_fwd0 I
	),
  Conv330_fwd0 AS (
	SELECT id, kfm_nt('Conv330_weight', I.value) AS value
	FROM AveragePool327_fwd0 I
	),
  Conv328_fwd0 AS (
	SELECT id, kfm_im2col('Conv328_weight', I.value, kernel:=5, padding:=2, stride:=1, 
	op_cost:=4775.261276941134) AS value
	FROM Relu324_fwd0 I
	),
  Conv329_fwd0 AS (
	SELECT id, kfm_im2col('Conv329_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=3436.635512563096) AS value
	FROM Relu325_fwd0 I
	),
  Relu333_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv330_fwd0 I
	),
  Relu331_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv328_fwd0 I
	),
  Relu332_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv329_fwd0 I
	),
  Conv334_fwd0 AS (
	SELECT id, kfm_im2col('Conv334_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=5156.446160031684) AS value
	FROM Relu332_fwd0 I
	),
  Relu335_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv334_fwd0 I
	),
  Concat336_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu323_fwd0 I1 
	INNER JOIN Relu331_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu335_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu333_fwd0 I4 on I1.id=I4.id
	),
  Conv337_fwd0 AS (
	SELECT id, kfm_im2col('Conv337_weight', I.value, kernel:=3, padding:=0, stride:=2, 
	op_cost:=13601.346719100473) AS value
	FROM Concat336_fwd0 I
	),
  Conv338_fwd0 AS (
	SELECT id, kfm_nt('Conv338_weight', I.value) AS value
	FROM Concat336_fwd0 I
	),
  MaxPool340_fwd0 AS (
	SELECT id, maxpool(I.value, kernel:=3, padding:=0, stride:=2, op_cost:=19.681670922873536) AS value
	FROM Concat336_fwd0 I
	),
  Relu341_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv337_fwd0 I
	),
  Relu342_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv338_fwd0 I
	),
  Conv343_fwd0 AS (
	SELECT id, kfm_im2col('Conv343_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=3436.635512563096) AS value
	FROM Relu342_fwd0 I
	),
  Relu344_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv343_fwd0 I
	),
  Conv345_fwd0 AS (
	SELECT id, kfm_im2col('Conv345_weight', I.value, kernel:=3, padding:=0, stride:=2, 
	op_cost:=1133.0081894600867) AS value
	FROM Relu344_fwd0 I
	),
  Relu346_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv345_fwd0 I
	),
  Concat347_fwd0 AS (
	SELECT I1.id, concat_array(3, input1:=I1.value, input2:=I2.value, input3:=I3.value) AS value
	FROM Relu341_fwd0 I1 
	INNER JOIN Relu346_fwd0 I2 on I1.id=I2.id
	INNER JOIN MaxPool340_fwd0 I3 on I1.id=I3.id
	),
  Conv348_fwd0 AS (
	SELECT id, kfm_nt('Conv348_weight', I.value) AS value
	FROM Concat347_fwd0 I
	),
  Conv349_fwd0 AS (
	SELECT id, kfm_nt('Conv349_weight', I.value) AS value
	FROM Concat347_fwd0 I
	),
  Conv350_fwd0 AS (
	SELECT id, kfm_nt('Conv350_weight', I.value) AS value
	FROM Concat347_fwd0 I
	),
  AveragePool355_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=52.484455794329435) AS value
	FROM Concat347_fwd0 I
	),
  Relu351_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv348_fwd0 I
	),
  Relu352_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv349_fwd0 I
	),
  Relu353_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv350_fwd0 I
	),
  Conv358_fwd0 AS (
	SELECT id, kfm_nt('Conv358_weight', I.value) AS value
	FROM AveragePool355_fwd0 I
	),
  Conv356_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv356_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu352_fwd0 I
	),
  Conv357_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv357_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu353_fwd0 I
	),
  Relu361_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv358_fwd0 I
	),
  Relu359_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv356_fwd0 I
	),
  Relu360_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv357_fwd0 I
	),
  Conv362_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv362_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu359_fwd0 I
	),
  Conv363_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv363_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu360_fwd0 I
	),
  Relu364_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv362_fwd0 I
	),
  Relu365_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv363_fwd0 I
	),
  Conv366_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv366_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu365_fwd0 I
	),
  Relu367_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv366_fwd0 I
	),
  Conv368_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv368_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu367_fwd0 I
	),
  Relu369_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv368_fwd0 I
	),
  Concat370_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu351_fwd0 I1 
	INNER JOIN Relu364_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu369_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu361_fwd0 I4 on I1.id=I4.id
	),
  Conv371_fwd0 AS (
	SELECT id, kfm_nt('Conv371_weight', I.value) AS value
	FROM Concat370_fwd0 I
	),
  Conv372_fwd0 AS (
	SELECT id, kfm_nt('Conv372_weight', I.value) AS value
	FROM Concat370_fwd0 I
	),
  Conv373_fwd0 AS (
	SELECT id, kfm_nt('Conv373_weight', I.value) AS value
	FROM Concat370_fwd0 I
	),
  AveragePool378_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=52.484455794329435) AS value
	FROM Concat370_fwd0 I
	),
  Relu374_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv371_fwd0 I
	),
  Relu375_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv372_fwd0 I
	),
  Relu376_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv373_fwd0 I
	),
  Conv381_fwd0 AS (
	SELECT id, kfm_nt('Conv381_weight', I.value) AS value
	FROM AveragePool378_fwd0 I
	),
  Conv379_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv379_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu375_fwd0 I
	),
  Conv380_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv380_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu376_fwd0 I
	),
  Relu384_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv381_fwd0 I
	),
  Relu382_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv379_fwd0 I
	),
  Relu383_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv380_fwd0 I
	),
  Conv385_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv385_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu382_fwd0 I
	),
  Conv386_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv386_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu383_fwd0 I
	),
  Relu387_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv385_fwd0 I
	),
  Relu388_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv386_fwd0 I
	),
  Conv389_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv389_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu388_fwd0 I
	),
  Relu390_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv389_fwd0 I
	),
  Conv391_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv391_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu390_fwd0 I
	),
  Relu392_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv391_fwd0 I
	),
  Concat393_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu374_fwd0 I1 
	INNER JOIN Relu387_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu392_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu384_fwd0 I4 on I1.id=I4.id
	),
  Conv394_fwd0 AS (
	SELECT id, kfm_nt('Conv394_weight', I.value) AS value
	FROM Concat393_fwd0 I
	),
  Conv395_fwd0 AS (
	SELECT id, kfm_nt('Conv395_weight', I.value) AS value
	FROM Concat393_fwd0 I
	),
  Conv396_fwd0 AS (
	SELECT id, kfm_nt('Conv396_weight', I.value) AS value
	FROM Concat393_fwd0 I
	),
  AveragePool401_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=52.484455794329435) AS value
	FROM Concat393_fwd0 I
	),
  Relu397_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv394_fwd0 I
	),
  Relu398_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv395_fwd0 I
	),
  Relu399_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv396_fwd0 I
	),
  Conv404_fwd0 AS (
	SELECT id, kfm_nt('Conv404_weight', I.value) AS value
	FROM AveragePool401_fwd0 I
	),
  Conv402_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv402_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu398_fwd0 I
	),
  Conv403_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv403_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu399_fwd0 I
	),
  Relu407_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv404_fwd0 I
	),
  Relu405_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv402_fwd0 I
	),
  Relu406_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv403_fwd0 I
	),
  Conv408_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv408_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu405_fwd0 I
	),
  Conv409_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv409_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu406_fwd0 I
	),
  Relu410_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv408_fwd0 I
	),
  Relu411_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv409_fwd0 I
	),
  Conv412_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv412_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu411_fwd0 I
	),
  Relu413_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv412_fwd0 I
	),
  Conv414_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv414_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu413_fwd0 I
	),
  Relu415_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv414_fwd0 I
	),
  Concat416_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu397_fwd0 I1 
	INNER JOIN Relu410_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu415_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu407_fwd0 I4 on I1.id=I4.id
	),
  Conv417_fwd0 AS (
	SELECT id, kfm_nt('Conv417_weight', I.value) AS value
	FROM Concat416_fwd0 I
	),
  Conv418_fwd0 AS (
	SELECT id, kfm_nt('Conv418_weight', I.value) AS value
	FROM Concat416_fwd0 I
	),
  Conv419_fwd0 AS (
	SELECT id, kfm_nt('Conv419_weight', I.value) AS value
	FROM Concat416_fwd0 I
	),
  AveragePool424_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=52.484455794329435) AS value
	FROM Concat416_fwd0 I
	),
  Relu420_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv417_fwd0 I
	),
  Relu421_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv418_fwd0 I
	),
  Relu422_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv419_fwd0 I
	),
  Conv427_fwd0 AS (
	SELECT id, kfm_nt('Conv427_weight', I.value) AS value
	FROM AveragePool424_fwd0 I
	),
  Conv425_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv425_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu421_fwd0 I
	),
  Conv426_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv426_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu422_fwd0 I
	),
  Relu430_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv427_fwd0 I
	),
  Relu428_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv425_fwd0 I
	),
  Relu429_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv426_fwd0 I
	),
  Conv431_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv431_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu428_fwd0 I
	),
  Conv432_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv432_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu429_fwd0 I
	),
  Relu433_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv431_fwd0 I
	),
  Relu434_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv432_fwd0 I
	),
  Conv435_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv435_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu434_fwd0 I
	),
  Relu436_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv435_fwd0 I
	),
  Conv437_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv437_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu436_fwd0 I
	),
  Relu438_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv437_fwd0 I
	),
  Concat439_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu420_fwd0 I1 
	INNER JOIN Relu433_fwd0 I2 on I1.id=I2.id
	INNER JOIN Relu438_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu430_fwd0 I4 on I1.id=I4.id
	),
  Conv440_fwd0 AS (
	SELECT id, kfm_nt('Conv440_weight', I.value) AS value
	FROM Concat439_fwd0 I
	),
  Conv441_fwd0 AS (
	SELECT id, kfm_nt('Conv441_weight', I.value) AS value
	FROM Concat439_fwd0 I
	),
  MaxPool443_fwd0 AS (
	SELECT id, maxpool(I.value, kernel:=3, padding:=0, stride:=2, op_cost:=11.429948150765076) AS value
	FROM Concat439_fwd0 I
	),
  Relu444_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv440_fwd0 I
	),
  Relu445_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv441_fwd0 I
	),
  Conv446_fwd0 AS (
	SELECT id, kfm_im2col('Conv446_weight', I.value, kernel:=3, padding:=0, stride:=2, 
	op_cost:=1645.4362858705556) AS value
	FROM Relu444_fwd0 I
	),
  Conv447_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv447_weight', I.value, 1, 7, 0, 3, 1
		) AS value
	FROM Relu445_fwd0 I
	),
  Relu448_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv446_fwd0 I
	),
  Relu449_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv447_fwd0 I
	),
  Conv450_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv450_weight', I.value, 7, 1, 3, 0, 1
		) AS value
	FROM Relu449_fwd0 I
	),
  Relu451_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv450_fwd0 I
	),
  Conv452_fwd0 AS (
	SELECT id, kfm_im2col('Conv452_weight', I.value, kernel:=3, padding:=0, stride:=2, 
	op_cost:=987.2617715223334) AS value
	FROM Relu451_fwd0 I
	),
  Relu453_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv452_fwd0 I
	),
  Concat454_fwd0 AS (
	SELECT I1.id, concat_array(3, input1:=I1.value, input2:=I2.value, input3:=I3.value) AS value
	FROM Relu448_fwd0 I1 
	INNER JOIN Relu453_fwd0 I2 on I1.id=I2.id
	INNER JOIN MaxPool443_fwd0 I3 on I1.id=I3.id
	),
  Conv455_fwd0 AS (
	SELECT id, kfm_nt('Conv455_weight', I.value) AS value
	FROM Concat454_fwd0 I
	),
  Conv456_fwd0 AS (
	SELECT id, kfm_nt('Conv456_weight', I.value) AS value
	FROM Concat454_fwd0 I
	),
  Conv457_fwd0 AS (
	SELECT id, kfm_nt('Conv457_weight', I.value) AS value
	FROM Concat454_fwd0 I
	),
  AveragePool462_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=19.04991358460846) AS value
	FROM Concat454_fwd0 I
	),
  Relu458_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv455_fwd0 I
	),
  Relu459_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv456_fwd0 I
	),
  Relu460_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv457_fwd0 I
	),
  Conv466_fwd0 AS (
	SELECT id, kfm_nt('Conv466_weight', I.value) AS value
	FROM AveragePool462_fwd0 I
	),
  Conv463_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv463_weight', I.value, 1, 3, 0, 1, 1
		) AS value
	FROM Relu459_fwd0 I
	),
  Conv464_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv464_weight', I.value, 3, 1, 1, 0, 1
		) AS value
	FROM Relu459_fwd0 I
	),
  Conv465_fwd0 AS (
	SELECT id, kfm_im2col('Conv465_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=4607.98359698094) AS value
	FROM Relu460_fwd0 I
	),
  Relu470_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv466_fwd0 I
	),
  Relu467_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv463_fwd0 I
	),
  Relu468_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv464_fwd0 I
	),
  Relu469_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv465_fwd0 I
	),
  Concat471_fwd0 AS (
	SELECT I1.id, concat_array(2, input1:=I1.value, input2:=I2.value) AS value
	FROM Relu467_fwd0 I1 
	INNER JOIN Relu468_fwd0 I2 on I1.id=I2.id
	),
  Conv472_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv472_weight', I.value, 1, 3, 0, 1, 1
		) AS value
	FROM Relu469_fwd0 I
	),
  Conv473_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv473_weight', I.value, 3, 1, 1, 0, 1
		) AS value
	FROM Relu469_fwd0 I
	),
  Relu474_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv472_fwd0 I
	),
  Relu475_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv473_fwd0 I
	),
  Concat476_fwd0 AS (
	SELECT I1.id, concat_array(2, input1:=I1.value, input2:=I2.value) AS value
	FROM Relu474_fwd0 I1 
	INNER JOIN Relu475_fwd0 I2 on I1.id=I2.id
	),
  Concat477_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu458_fwd0 I1 
	INNER JOIN Concat471_fwd0 I2 on I1.id=I2.id
	INNER JOIN Concat476_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu470_fwd0 I4 on I1.id=I4.id
	),
  Conv478_fwd0 AS (
	SELECT id, kfm_nt('Conv478_weight', I.value) AS value
	FROM Concat477_fwd0 I
	),
  Conv479_fwd0 AS (
	SELECT id, kfm_nt('Conv479_weight', I.value) AS value
	FROM Concat477_fwd0 I
	),
  Conv480_fwd0 AS (
	SELECT id, kfm_nt('Conv480_weight', I.value) AS value
	FROM Concat477_fwd0 I
	),
  AveragePool485_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=3, padding:=1, stride:=1, op_cost:=30.479861735373536) AS value
	FROM Concat477_fwd0 I
	),
  Relu481_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv478_fwd0 I
	),
  Relu482_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv479_fwd0 I
	),
  Relu483_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv480_fwd0 I
	),
  Conv489_fwd0 AS (
	SELECT id, kfm_nt('Conv489_weight', I.value) AS value
	FROM AveragePool485_fwd0 I
	),
  Conv486_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv486_weight', I.value, 1, 3, 0, 1, 1
		) AS value
	FROM Relu482_fwd0 I
	),
  Conv487_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv487_weight', I.value, 3, 1, 1, 0, 1
		) AS value
	FROM Relu482_fwd0 I
	),
  Conv488_fwd0 AS (
	SELECT id, kfm_im2col('Conv488_weight', I.value, kernel:=3, padding:=1, stride:=1, 
	op_cost:=4607.98359698094) AS value
	FROM Relu483_fwd0 I
	),
  Relu493_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv489_fwd0 I
	),
  Relu490_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv486_fwd0 I
	),
  Relu491_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv487_fwd0 I
	),
  Relu492_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv488_fwd0 I
	),
  Concat494_fwd0 AS (
	SELECT I1.id, concat_array(2, input1:=I1.value, input2:=I2.value) AS value
	FROM Relu490_fwd0 I1 
	INNER JOIN Relu491_fwd0 I2 on I1.id=I2.id
	),
  Conv495_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv495_weight', I.value, 1, 3, 0, 1, 1
		) AS value
	FROM Relu492_fwd0 I
	),
  Conv496_fwd0 AS (
	SELECT id, kfm_im2col_ns(
		'Conv496_weight', I.value, 3, 1, 1, 0, 1
		) AS value
	FROM Relu492_fwd0 I
	),
  Relu497_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv495_fwd0 I
	),
  Relu498_fwd0 AS (
	SELECT id, relu(I.value) AS value
	FROM Conv496_fwd0 I
	),
  Concat499_fwd0 AS (
	SELECT I1.id, concat_array(2, input1:=I1.value, input2:=I2.value) AS value
	FROM Relu497_fwd0 I1 
	INNER JOIN Relu498_fwd0 I2 on I1.id=I2.id
	),
  Concat500_fwd0 AS (
	SELECT I1.id, concat_array(4, input1:=I1.value, input2:=I2.value, input3:=I3.value, input4:=I4.value) AS value
	FROM Relu481_fwd0 I1 
	INNER JOIN Concat494_fwd0 I2 on I1.id=I2.id
	INNER JOIN Concat499_fwd0 I3 on I1.id=I3.id
	INNER JOIN Relu493_fwd0 I4 on I1.id=I4.id
	),
  AveragePool502_fwd0 AS (
	SELECT id, avgpool(I.value, kernel:=7, padding:=0, stride:=7, op_cost:=3.1101899729972997) AS value
	FROM Concat500_fwd0 I
	),
  Reshape503_fwd0 AS (
	SELECT id, array_agg(t.value) as value
	FROM (SELECT id, unnest(I.value) as value FROM AveragePool502_fwd0 I) AS t
	GROUP BY id
	),
  MatMul505_fwd0 AS (
	SELECT id, mvm('Transpose504_input', I.value, op_cost:=1.2437722597093694) AS value
	FROM Reshape503_fwd0 I
	)
SELECT l.name AS res FROM
cifar10_labels l
JOIN (
	SELECT argmax(value) AS label FROM MatMul505_fwd0) t
	ON t.label = l.label