shader_type canvas_item;
uniform sampler2D lighting : hint_default_black;
uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float light_bright = float(1);

uniform vec2 frames = vec2(8.0,8.0);

void fragment()
{
	vec4 current_texture;
	vec4 normal_texture;
	vec4 lighting_texture;
	vec2 outp;
	vec2 noiseuv = UV;
	vec2 moduv = vec2(0,0);
	
	moduv = UV;

	noiseuv = moduv;
	noiseuv = modf(noiseuv * frames, outp);
	noiseuv = noiseuv / frames;
	
	current_texture = texture(TEXTURE,moduv);
	normal_texture = texture(NORMAL_TEXTURE,moduv);
	lighting_texture = texture(lighting,moduv);
	
	NORMAL_MAP = vec3(normal_texture[0], 1.0 - normal_texture[1],normal_texture[2]);

	COLOR = current_texture;

	if(lighting_texture.r > .2f)
	{
		COLOR = lighting_texture * light_color * light_bright;
	}
}