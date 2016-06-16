


uniform sampler2D tex;
float a = sin(1.0 * u_time);
if(_geometry.position.x < 0.0){
  _geometry.position.y += a * texture2D(tex, vec2(1.0, 1.0)).r;
}



