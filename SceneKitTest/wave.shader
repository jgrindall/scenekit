float a = 0.5 + sin(u_time);
if(_geometry.position.y > 0.4 && _geometry.position.y < 0.6){
  _geometry.position.y += a;
}
