uniform sampler2D tex;
float a = sin(0.4 * u_time);
float i = floor(_geometry.position.x);
float j = floor(_geometry.position.z);
float h = texture2D(tex, vec2(i, j)).r;
_geometry.position.y += a * h;

