shader_type canvas_item;
render_mode blend_add;

uniform sampler2D colors : hint_default_black;

vec4 color_gradient(vec4 input)
{
	vec4 return_color;
	vec4 grad;
	float color_shift = 0.0;
	float color_level = input.r;
		
	grad = texture(colors, vec2(color_level,0.0));
	
	return_color.r = grad.r;
	return_color.g = grad.g;
	return_color.b = grad.b;
	return_color.a = input.a * grad.a;
	return return_color;
}

void fragment()
{
	vec4 current_texture;
	vec3 grad;
	vec2 outp;
	vec2 noiseuv = UV;
	vec2 moduv = vec2(0,0);
	
	moduv = UV;
	current_texture = texture(TEXTURE,moduv);
	COLOR = color_gradient(current_texture);
}