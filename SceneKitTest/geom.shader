uniform sampler2D heightMapTexture;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

vec3 pos = _geometry.position.xyz;

%shared%

if(_middle){
	_geometry.position.y += ht;
}

