uniform sampler2D tex;
float a = sin(0.4 * u_time);
if(_geometry.position.x < 0.75){
  _geometry.position.y += a * texture2D(tex, vec2(1.0, 1.0)).r;
}



