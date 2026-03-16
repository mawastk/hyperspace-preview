import bake_mesh
import base64
import gzip

def _bake(segment, template_xml):

    result = bake_mesh._mawa_bakeMesh(
        segment,
        "none",
        template_xml
    )
    
    byte = base64.b64encode(result)
    byte_str = byte.decode("utf-8")
    
    return byte_str