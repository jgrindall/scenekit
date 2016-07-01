uniform sampler2D tex;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;   // 0.2
float j = _geometry.position.x / size;	// from 0 to maxJ
float i = _geometry.position.z / size;	// from 0 to maxI

float rnd_j = floor(j);
float rnd_i = floor(i);

float abs_j = j / maxJ;  // from 0 to 1
float abs_i = i / maxI;  // from 0 to 1

float dx = j - rnd_j;
float dy = i - rnd_i;
if(dx > eps/2.0 && dx < 1.0 - eps/2.0 && dy > eps/2.0 && dy < 1.0 - eps/2.0){
	_geometry.position.y = 200.0 * texture2D(tex, vec2(abs_j, abs_i)).r;
}

