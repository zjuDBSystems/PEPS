select load_model(ARRAY['conv_0_weight','conv_1_weight','conv_2_weight','fc_weight']);
WITH
  input_feature_map AS (
	SELECT id, news_text AS value
	from agnews),
  conv_0 as(
    SELECT id, conv_text(
		'conv_0_weight', I.value, 3, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I
    ),
  conv_1 as(
    SELECT id, conv_text(
		'conv_1_weight', I.value, 4, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I
    ),
  conv_2 as(
    SELECT id, conv_text(
		'conv_2_weight', I.value, 5, 96, 0, 0, 1
		) AS value
	FROM input_feature_map I
    ),
  concat_0 as(
    select I1.id, array_cat(array_cat(I1.value, I2.value), I3.value) as value
    FROM conv_0 I1
        INNER JOIN conv_1 I2 on I1.id=I2.id
        INNER JOIN conv_2 I3 on I1.id=I3.id
    ),
  matmul_0 AS (
	SELECT id, mvm('fc_weight', I.value) AS value
	FROM concat_0 I
	)
SELECT id, argmax(value)-1 AS label FROM matmul_0;

select id, pytext(news_text) from agnews;
CREATE OR REPLACE FUNCTION pytext(input real[])
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
      # output = result['output'] 
      predicted_class = result['output']
      # plpy.info(f"[pycolor] output:{output}")
      # predicted_class = np.argmax(np.array(output))
      return predicted_class
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select id, pytext(news_text) from agnews;
CREATE OR REPLACE FUNCTION pytext(input real[])
RETURNS text
AS $$
      import numpy as np 
      import onnx
      from onnx import shape_inference
      import onnxruntime as rt
      import plpy
       
      model_path = "/home/pyc/workspace/DBOCG/models/textcnn.onnx"
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