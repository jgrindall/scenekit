uniform sampler2D tex;
uniform float maxI;
uniform float maxJ;
uniform float size;
float j = floor(_geometry.position.x) / maxJ;
float i = floor(_geometry.position.z) / maxI;
_geometry.position.y = 20.0*texture2D(tex, vec2(i, j)).r;

