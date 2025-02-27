import numpy as np 
from onnx import shape_inference
import onnxruntime as rt

cifar10_labels = [
    "airplane", "automobile", "bird", "cat", "deer",
    "dog", "frog", "horse", "ship", "truck"
]
model_path = "/home/pyc/workspace/DBOCG/models/resnext29.onnx"
np_input = np.array(input, dtype=np.float32)
np_input = np_input.reshape(1, 3, 32, 32)

sess_options = rt.SessionOptions()
 
sess_options.intra_op_num_threads = 1
sess_options.graph_optimization_level = rt.GraphOptimizationLevel.ORT_DISABLE_ALL

sess = rt.InferenceSession(model_path, sess_options)
output = sess.run(None, {
"input": np_input
})
plpy.info("[pycolor] executing...")
predicted_class = np.argmax(output[0], axis=1)[0]
return cifar10_labels[predicted_class]