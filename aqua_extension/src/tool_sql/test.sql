\i /home/pyc/workspace/CUPS/aqua_extension/src/tool_sql/init.sql

select color(c.image) from cifar c;

select count(id), color(c.image) o from cifar c 
where c.create_date>='2022-01-01' and c.create_date<='2022-12-31' 
group by o;

CREATE TABLE cifar10_labels(
  label integer PRIMARY KEY,
  name text NOT NULL
);

INSERT INTO cifar10_labels VALUES 
(1, 'airplane'),
(2, 'automobile'),
(3, 'bird'),
(4, 'cat'),
(5, 'deer'),
(6, 'dog'),
(7, 'frog'),
(8, 'horse'),
(9, 'ship'),
(10, 'truck');

select color(c.image) from cifar c;


select pycolor((c.image).array_data) o, count(id) from cifar c group by o;
 
select pycolor((c.image).array_data) o from cifar c where c.create_date<='2022-03-21';


-- test join expands size 
select c.id, pycolor((c.image).array_data) o from cifar c join fabric f on c.id=f.id;

-- test udf predicate 
select c.id from cifar c join fabric f \
on c.id=f.id 
where f.type='female' and pycolor((c.image).array_data) ='cat';

select pycolor((c.image).array_data) o, count(id) from cifar c group by o;

select id from cifar c where pycolor((c.image).array_data)='airplane';

select id, pycolor((c.image).array_data) from cifar c;

CREATE OR REPLACE FUNCTION pycolor(input real[])
RETURNS text
AS $$
      import numpy as np 
      import onnx
      from onnx import shape_inference
      import onnxruntime as rt
      import plpy
      
      cifar10_labels = [
            "airplane", "automobile", "bird", "cat", "deer",
            "dog", "frog", "horse", "ship", "truck"
      ]
      model_path = "/home/pyc/workspace/DBOCG/models/resnext50.onnx"
      # model_path = "/home/pyc/workspace/DBOCG/models/resnext29.onnx"
      # model_path = "/home/pyc/workspace/DBOCG/models/inception_v3.onnx"
      np_input = np.array(input, dtype=np.float32)
      np_input = np_input.reshape(1, 3, 32, 32)

      sess_options = rt.SessionOptions()
      sess_options.inter_op_num_threads = 1
      sess_options.intra_op_num_threads = 4
      sess_options.graph_optimization_level = rt.GraphOptimizationLevel.ORT_DISABLE_ALL

      sess = rt.InferenceSession(model_path, sess_options)
      output = sess.run(None, {
      "input": np_input
      })
      plpy.info("[pycolor] executing...")
      predicted_class = np.argmax(output[0], axis=1)[0]
      return cifar10_labels[predicted_class]
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select pycolor(virtual_arr(c.image)) from cifar c;

model_path = "/home/pyc/workspace/aqua/aqua_extension/res18.onnx"

model_path = "/home/pyc/workspace/DBOCG/models/resnext29_8_14.onnx"
model_path = "/home/pyc/workspace/DBOCG/models/inception_v3.onnx"

CREATE TABLE split_test (
    val real[][]
);

-- 插入二维数组
WITH numbers AS (
  SELECT generate_series(1, 1024*32) AS num
),
grouped AS (
  SELECT ((num - 1) / 1024 + 1) AS row, array_agg(num) AS one_dim_array
  FROM numbers
  GROUP BY row
  ORDER BY row
)
INSERT INTO split_test (val)
SELECT array_agg(one_dim_array) AS val
FROM grouped;

\i /home/pyc/workspace/CUPS/aqua_extension/src/tool_sql/init.sql
set min_parallel_table_scan_size=0;
set min_parallel_index_scan_size=0;
set parallel_tuple_cost=0;
set parallel_setup_cost=0;
set max_parallel_workers_per_gather=8;
set max_parallel_workers=16;



select pycolor((c.image).array_data) from cifar c;
CREATE OR REPLACE FUNCTION pycolor(input real[])
RETURNS text
AS $$
      import requests
      import json
      import plpy
      import numpy as np
      
      cifar10_labels = [
            "airplane", "automobile", "bird", "cat", "deer",
            "dog", "frog", "horse", "ship", "truck"
      ]
       
      url = 'http://127.0.0.1:8000/predict/'  
      # url = 'http://127.0.0.1:8080/predictions/InceptionV3'
       
      headers = {'Content-Type': 'application/json'}  
      data = json.dumps({"input": input})         
      response = requests.post(url, headers=headers, data=data)  
      result = response.json() 
      # output = result['output'] 
      predicted_class = result['output']
      # predicted_class = result
      # predicted_class = np.argmax(np.array(output))
      return cifar10_labels[predicted_class]
      
$$ LANGUAGE plpython3u PARALLEL SAFE;

select pycolor(virtual_arr(c.image)) from cifar c;
select pycolor((c.image).array_data) from cifar c;

select id, pycolor((c.image).array_data) from cifar c;
CREATE OR REPLACE FUNCTION pycolor(input real[])
RETURNS text
AS $$
      import torch  
      import plpy
      
      cifar10_labels = [
            "airplane", "automobile", "bird", "cat", "deer",
            "dog", "frog", "horse", "ship", "truck"
      ]
      # model_path = "/home/pyc/workspace/DBOCG/models/resnet18.onnx"
      model_path = "/home/pyc/workspace/baseline/torch/models/resnext29.pt"
      # model_path = "/home/pyc/workspace/DBOCG/models/inception_v3.onnx"
      torch.set_num_threads(10)
      input_tensor  = torch.tensor(input)  
      input_tensor = input_tensor.view(1, 3, 32, 32)

      model = torch.jit.load(model_path)
      model.eval()   
      with torch.no_grad():  
            output = model(input_tensor)  
      _, predicted_class = torch.max(output, 1)  
      # plpy.info("[pycolor] executing...")
      return cifar10_labels[int(predicted_class)]
      
$$ LANGUAGE plpython3u PARALLEL SAFE;





CREATE OR REPLACE FUNCTION pycolor(input real[])
RETURNS text
AS $$
    import numpy as np
    import onnxruntime as rt
    import os

    # CIFAR-10 标签
    cifar10_labels = [
        "airplane", "automobile", "bird", "cat", "deer",
        "dog", "frog", "horse", "ship", "truck"
    ]

    # ONNX 模型路径
    model_path = "/home/pyc/workspace/models/cifar10/models/resnext50.onnx"

    # 处理输入数据
    np_input = np.array(input, dtype=np.float32)
    np_input = np_input.reshape(1, 3, 32, 32)  # 调整输入形状

    # 设置 ONNX 运行选项
    sess_options = rt.SessionOptions()
    sess_options.graph_optimization_level = rt.GraphOptimizationLevel.ORT_ENABLE_ALL  # 允许优化

    # 使用 GPU 进行推理
    providers = ["CUDAExecutionProvider", "CPUExecutionProvider"]
    sess = rt.InferenceSession(model_path, sess_options, providers=providers)

    # 运行推理
    output = sess.run(None, {"input": np_input})

    # 获取预测类别
    predicted_class = np.argmax(output[0], axis=1)[0]

    return cifar10_labels[predicted_class]
$$ LANGUAGE plpython3u PARALLEL SAFE;

CREATE OR REPLACE FUNCTION pycolor(input real[])
RETURNS text
AS $$
    import numpy as np
    import onnxruntime as rt
    
    # 如果还没有加载，才进行一次性初始化
    if 'sess' not in SD:
        sess_options = rt.SessionOptions()
        providers = ["CUDAExecutionProvider", "CPUExecutionProvider"]
        model_path = "/home/pyc/workspace/models/cifar10/models/resnext50.onnx"
        
        SD['sess'] = rt.InferenceSession(model_path, sess_options, providers=providers)
    
    # CIFAR-10 标签
    cifar10_labels = [
        "airplane", "automobile", "bird", "cat", "deer",
        "dog", "frog", "horse", "ship", "truck"
    ]
    
    # 从 SD 中取出已经加载好的 session
    sess = SD['sess']
    
    # 处理输入数据
    np_input = np.array(input, dtype=np.float32).reshape(1, 3, 32, 32)
    
    # 运行推理
    output = sess.run(None, {"input": np_input})
    
    # 获取预测类别
    predicted_class = np.argmax(output[0], axis=1)[0]
    
    return cifar10_labels[predicted_class]
$$ LANGUAGE plpython3u PARALLEL SAFE;


CREATE OR REPLACE FUNCTION pytext(input real[])
RETURNS text
AS $$
    import numpy as np
    import onnxruntime as rt
    
    # 如果还没有加载，才进行一次性初始化
    if 'sess' not in SD:
        sess_options = rt.SessionOptions()
        providers = ["CUDAExecutionProvider", "CPUExecutionProvider"]
        model_path = "/home/pyc/workspace/models/cifar10/models/textcnn.onnx"
        
        SD['sess'] = rt.InferenceSession(model_path, sess_options, providers=providers)
    
    # 从 SD 中取出已经加载好的 session
    sess = SD['sess']
    
    # 处理输入数据
    np_input = np.array(input, dtype=np.float32).reshape(1, 128, 96)
    
    # 运行推理
    output = sess.run(None, {"input": np_input})
    
    # 获取预测类别
    predicted_class = np.argmax(output[0], axis=1)[0]
    
    return predicted_class
$$ LANGUAGE plpython3u PARALLEL SAFE;


 