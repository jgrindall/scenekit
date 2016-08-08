uniform sampler2D heightMapTexture;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

vec3 pos = _geometry.position.xyz;

%shared%

if(dx > eps/2.0 && dx < 1.0 - eps/2.0 && dy > eps/2.0 && dy < 1.0 - eps/2.0){
	_geometry.position.y += 20.0 * texture2D(heightMapTexture, vec2(pix_j, pix_i)).r;
	//_geometry.normal = vec3(0, 0, 1);
}

