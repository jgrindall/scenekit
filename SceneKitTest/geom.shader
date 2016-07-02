uniform sampler2D heightMapTexture;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

float j = _geometry.position.x / size;	// from 0 to maxJ
float i = _geometry.position.z / size;	// from 0 to maxI

float rnd_j = floor(j);
float rnd_i = floor(i);

float pix_j = (rnd_j + 0.5) / maxJ;
float pix_i = (rnd_i + 0.5) / maxI;

float dx = j - rnd_j;
float dy = i - rnd_i;

if(dx > eps/2.0 && dx < 1.0 - eps/2.0 && dy > eps/2.0 && dy < 1.0 - eps/2.0){
	_geometry.position.y += 20.0 * texture2D(heightMapTexture, vec2(pix_j, pix_i)).r;
}

