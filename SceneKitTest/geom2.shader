
uniform float size;
uniform float num;
uniform float eps;

vec3 pos = _geometry.position.xyz;

float _iF = pos.x / size;
float _jF = pos.z / size;

float _i = floor(_iF);
float _j = floor(_jF);

if(_i == 2.0 && _j == 2.0){
	_geometry.position.y += 2.0;
}
