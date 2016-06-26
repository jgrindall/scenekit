uniform sampler2D tex;
float j = floor(_geometry.position.x);
float i = floor(_geometry.position.z);
_geometry.position.y += 0.0;
//texture2D(tex, vec2(i, j)).b;

