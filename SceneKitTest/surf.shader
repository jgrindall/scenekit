uniform sampler2D colorMapTexture;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float maxI;
uniform float maxJ;
uniform float size;
uniform float eps;

#pragma body

vec4 surfacePos = vec4(_surface.position, 1.0);
vec4 pos = u_inverseViewTransform * surfacePos;

%shared%

float colorIndex;

if(dx > eps && dx < 1.0 - eps && dy > eps && dy < 1.0 - eps){
    colorIndex = texture2D(colorMapTexture, vec2(pix_j, pix_i)).r;
	if(colorIndex < 0.5){
		_surface.diffuse = texture2D(texture0, vec2(dx, dy));
	}
	else{
		_surface.diffuse = texture2D(texture1, vec2(dx, dy));
	}
}
