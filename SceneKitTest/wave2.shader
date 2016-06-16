uniform sampler2D tex2;
_surface.diffuse = texture2D(tex2, _surface.diffuseTexcoord);
