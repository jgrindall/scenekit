uniform sampler2D colorMapTexture;
uniform sampler2D heightMapTexture;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

#pragma body

vec4 surfacePos = vec4(_surface.position, 1.0);
vec4 pos = u_inverseViewTransform * surfacePos;

float j = pos.x / size;						// from 0 to maxJ
float i = pos.z / size;						// from 0 to maxI
float y = pos.y;

float rnd_j = floor(j);
float rnd_i = floor(i);

float pix_j = (rnd_j + 0.5) / maxJ;			// 0 to 1
float pix_i = (rnd_i + 0.5) / maxI;			// 0 to 1

float dx = j - rnd_j;
float dz = i - rnd_i;

if(dx > eps && dx < 1.0 - eps && dz > eps && dz < 1.0 - eps){
	_surface.diffuse = texture2D(texture0, vec2(dx, dz));
}

else if(dx < eps){
	float pix_ht = (dx / eps);		// 0 to 1
	_surface.diffuse = texture2D(texture0, vec2(dz, pix_ht));
}







