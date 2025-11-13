shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;
uniform float distort_strenght = 0.0;
uniform float wave_strenght = 1.0;

void fragment() {

	vec2 center = vec2(0.5);
	vec2 center_vec = center - UV;

	center_vec *= (SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y) * wave_strenght;

	float dist = length(center_vec) * PI;

	float rotation_strenght = 60.0 / dist * PI * sin(distort_strenght/1.0) * distort_strenght;

	mat2 rot = mat2(vec2(sin(rotation_strenght), -cos(rotation_strenght)),
					vec2(cos(rotation_strenght), sin(rotation_strenght)));

	center_vec *= rot;

	vec2 modified = SCREEN_UV - center_vec * dist;
	COLOR = texture(SCREEN_TEXTURE, modified) * vec4(1.0,1.0,1.0, COLOR.a);
}