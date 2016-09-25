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

%shared%

float tex_x;
float tex_y;

if(_middle){
    tex_y = (dz - eps) / innerSize;
	tex_x = (dx - eps) / innerSize;
	_surface.diffuse = texture2D(texture1, vec2(tex_x, tex_y));
}
else {
    tex_y = pos.y / ht;
    tex_x = (left_y - left_x) / (size - 2.0 * left_x);
    _surface.diffuse = texture2D(texture0, vec2(tex_x, tex_y));
	//_surface.diffuse = vec4(0.0, 0.0, 0.0, 0.0);
	//_surface.ambient = vec4(0.0, 0.0, 0.0, 0.0);
	//_surface.transparent = vec4(0.0, 0.0, 0.0, 0.0);
}







