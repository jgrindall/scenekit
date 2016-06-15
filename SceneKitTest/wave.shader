uniform sampler2D tex;
float a = sin(2.0 * u_time);
if(_geometry.position.x < 0.0){
  _geometry.position.y += a * texture2D(tex, vec2(3.0, 0.0)).r;
}



