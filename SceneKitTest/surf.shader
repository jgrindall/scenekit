uniform sampler2D colorMapTexture;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

vec2 sincos(float t) { return vec2(sin(t), cos(t)); }

#pragma body

vec4 pos = vec4(_surface.position, 1.0);
vec4 pos2 = u_inverseViewTransform * pos;

float j = pos2.x / size;	// from 0 to maxJ
float i = pos2.z / size;	// from 0 to maxI

float rnd_j = floor(j);
float rnd_i = floor(i);

float pix_j = (rnd_j + 0.5) / maxJ;
float pix_i = (rnd_i + 0.5) / maxI;

float dx = j - rnd_j;
float dy = i - rnd_i;

if(dx > eps && dx < 1.0 - eps && dy > eps && dy < 1.0 - eps){
    _surface.diffuse = texture2D(texture1, vec2(dx, dy));
    if(mod(rnd_j + rnd_i, 2.0) < 0.5){
        _surface.diffuse = texture2D(texture0, vec2(dx, dy));
	}
}
