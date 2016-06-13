mat4 rotationAroundX(float angle)
{
return mat4(1.0,    0.0,         0.0,        0.0,
0.0,    cos(angle), -sin(angle), 0.0,
0.0,    sin(angle),  cos(angle), 0.0,
0.0,    0.0,         0.0,        1.0);
}

#pragma body

uniform float twistFactor = 1.0;
float rotationAngle = _geometry.position.x * twistFactor;
mat4 rotationMatrix = rotationAroundX(rotationAngle);
_geometry.position *= rotationMatrix;
vec4 twistedNormal = vec4(_geometry.normal, 1.0) * rotationMatrix;
_geometry.normal   = twistedNormal.xyz;