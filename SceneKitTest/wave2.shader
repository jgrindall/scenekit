uniform sampler2D tex2;
if(_surface.position.y > 0.4){
    _surface.diffuse = texture2D(tex2, _surface.diffuseTexcoord);
}