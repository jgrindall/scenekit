uniform sampler2D tex;
float j = floor(_geometry.position.x) / 50.0;
float i = floor(_geometry.position.z) / 50.0;
_geometry.position.y += 10.0*texture2D(tex, vec2(i, j)).b;

