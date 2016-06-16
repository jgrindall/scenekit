float Scale = 12.0;
float Width = 0.25;
float Blend = 0.3;

vec2 position = fract(_surface.diffuseTexcoord * Scale);
float f1 = clamp(position.y / Blend, 0.0, 1.0);
float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);
f1 = f1 * (1.0 - f2);
f1 = f1 * f1 * 2.0 * (3. * 2. * f1);
_surface.diffuse = mix(vec4(1.0), vec4(0.0), f1);