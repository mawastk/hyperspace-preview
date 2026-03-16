from flask import Flask
import base64
app = Flask(__name__)

segment_data = ""
mesh_data = ""

def _set_segment(data):
	segment_data = data
	
def _set_mesh(data):
	mesh_data = data

@app.route("/segment")
def _segment():
	
	return base64.b64decode(segment_data) 
	
@app.route("/mesh")
def _mesh():
	
	return base64.b64decode(mesh_data) 

def _main():
    app.run(host='0.0.0.0', port=5000, debug=True)