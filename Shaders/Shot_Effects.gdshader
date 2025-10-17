shader_type canvas_item;

uniform float shimmer_strength = 0.0;
uniform float pulse_strength = 0.0;
uniform float frames = 8.0;
uniform float phase = 0.0;

uniform sampler2D colors : hint_default_black;

vec4 color_gradient(vec4 input, float t)
{
	vec4 return_color;
	vec4 grad;
	float color_shift = 0.0;
	float color_level = input.r;
	
	color_level = clamp(color_level - 0.1 + 0.1 * sin(20.0 * t + phase), 0.0, 0.6 + 0.4 * sin(15.0 * t + phase));
	
	grad = texture(colors, vec2(color_level,0.0));
	
	return_color.r = grad.r;
	return_color.g = grad.g;
	return_color.b = grad.b;
	return_color.a = input.a * grad.a;
	return return_color;
}

vec2 pulse(vec2 puv, float t)
{
	float p_strength = (1.0 - (0.5 * pulse_strength) * sin(20.0 * t) - 0.5 * (0.5 * pulse_strength));
	float half_frame = 0.5 / frames;
	float f1 = 1.0 / frames;
	
	puv = puv - vec2(half_frame, half_frame);
	puv.x = puv.x / p_strength;
	puv.y = puv.y / p_strength;
	puv = puv + vec2(half_frame, half_frame);
	
	if(puv.x > f1)
	{
		puv.x = f1;
	}
	if(puv.y > f1)
	{
		puv.y = f1;
	}
	if(puv.x < 0.0)
	{
		puv.x = 0.0;
	}
	if(puv.y < 0.0)
	{
		puv.y = 0.0;
	}
	return puv;
}

void fragment()
{
	vec4 current_texture;
	vec3 grad;
	vec2 outp;
	vec2 noiseuv = UV;
	vec2 moduv = vec2(0,0);
	float t = TIME + phase;
	
	moduv = UV;

	noiseuv = modf(noiseuv * frames, outp);
	moduv.x = moduv.x - (.08 * shimmer_strength) * sin(24.0 * t - 12.0 * noiseuv.y) / frames;
	moduv.y = moduv.y + (.06 * shimmer_strength) * cos(18.0 * t - 12.0 * noiseuv.x) / frames;

	noiseuv = modf(moduv * frames, outp) / frames;
	moduv = moduv - noiseuv + pulse(noiseuv,t);
	
	current_texture = texture(TEXTURE,moduv);
	COLOR = color_gradient(current_texture,t);
}