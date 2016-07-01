//uniform sampler2D tex2;
uniform float maxI;
uniform float maxJ;
uniform float size;
vec4 pos = vec4(_surface.position, 1.0);
vec4 pos2 = u_inverseViewTransform * pos;
float j = floor(pos2.x / size);
float i = floor(pos2.z / size);
if(mod(i + j, 2.0) < 0.5){
	_surface.diffuse.r = 255.0;
}
