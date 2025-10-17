shader_type canvas_item;
uniform sampler2D burn : hint_default_black;
uniform sampler2D flag_mask : hint_default_black;
uniform sampler2D lighting : hint_default_black;
uniform vec4 flag_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 burn_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float light_bright = float(1);
uniform float burn_bright = float(1);

uniform vec2 frames = vec2(8.0,8.0);

//Cloak Shader
uniform float cloak_strength = 0.0;

//Freeze
const vec4 freeze_color = vec4(0.16, 0.19, 0.21, 1.0);
uniform float freeze_strength = 0.0;

//Acid
const vec4 acid_color_a = vec4(0.66, 1.00, 0.56, 1.0);
const vec4 acid_color_b = vec4(0.98, 1.00, 0.90, 1.0);
uniform float acid_strength = 0.0;

//Damage Shader
uniform float damage_strength = 0.0;

//Burnt Shader
uniform float burnt_strength = 0.0;

//Dissolve Shader
const vec4 dissolve_a = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 dissolve_b = vec4(1.0, 0.3, 0.19, 1.0);
const vec4 dissolve_c = vec4(0.35, 0.0, 0.0, 1.0);
const int OCTAVES = 5;
uniform float dissolve_strength = 0.0;

//Fire
const vec4 fire_red = vec4(0.98, 0.18, 0.07, 1.0);
const vec4 fire_yellow = vec4(1.00, 0.84, 0.66, 1.0);
uniform float fire_strength = 0.0;

//Shock
const vec4 shock_white = vec4(0.88, 0.97, 1.00, 1.00);
const vec4 shock_color = vec4(0.32, 0.78, 1.00, 1.00);
uniform float shock_strength = 0.0;

//Shield
const vec4 shield_color_a = vec4(0.31, 0.70, 1.0, 0.58);
const vec4 shield_color_b = vec4(0.0, 0.23, 0.54, 0.68);
uniform float shield_strength = 0.0;
uniform float shield_charging = 0.0;
const vec4 shield_damage_color = vec4(1,1,1,1);

//Shield Damage
uniform float shield_damage_strength = 0.0;

//Build
uniform float build_strength = 0.0;

//Swirl
uniform float swirl_strength = 0.0;

//Noise
uniform vec2 offset;
const float simplex_scale = 0.5;

//Selected
const vec4 select_color = vec4(1,1,1,1);
uniform float select_strength = 0.0;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
	//return fract(sin(dot(coord, vec2(56.0934483, 78.3674596)) * 1000.0) * 1000.0);
}

vec3 mod289_3(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289_2(vec2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
    return mod289_3(((x*34.0)+1.0)*x);
}

float snoise(vec2 v) {
    vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                  0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                 -0.577350269189626,  // -1.0 + 2.0 * C.x
                  0.024390243902439); // 1.0 / 41.0
    // First corner
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    vec2 i1;
    //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
    //i1.y = 1.0 - i1.x;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    // x0 = x0 - 0.0 + 0.0 * C.xx ;
    // x1 = x0 - i1 + 1.0 * C.xx ;
    // x2 = x0 - 1.0 + 2.0 * C.xx ;
    vec4 x12 = vec4(x0.xy, x0.xy) + C.xxzz;
    x12.xy -= i1;

    // Permutations
    i = mod289_2(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    	+ i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), vec3(0.0));
    m = m*m ;
    m = m*m ;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

    // Compute final noise value at P
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.8;
	vec2 new_offset = offset;

	for(int i = 0; i < OCTAVES; i++){
		value += snoise((coord + new_offset) * simplex_scale);
		coord *= 2.0;
		scale *= 0.75;
	}
	value = value / float(OCTAVES) + 0.5;
	value = clamp(value,0.0,1.0);
	return value;
}

vec4 freeze(vec4 original, vec2 uv, vec2 noiseuv)
{
	vec4 new_col;
	vec4 ice = vec4(0.0,0.0,0.0,1.0);
	float intensity = 0.0;
	intensity = (original.r + original.g + original.b) / 3.0;
	ice = vec4(intensity,intensity,intensity,1.0);
	ice = mix(ice, freeze_color, 0.75);
	new_col = mix(original, ice, freeze_strength);
	new_col.a *= original.a;
	return new_col;
}

vec4 damage(vec4 original, vec2 uv, vec2 noiseuv)
{
	vec4 new_col;
	vec4 damage_color_a = vec4(1.0,1.0,1.0,1.0);//vec4(1.0,0.0,0.0,1.0);
	vec4 damage_color_b = vec4(1.0,1.0,1.0,1.0);//vec4(1.0,0.4,0.2,1.0);
	vec4 damage_color_c = vec4(1.0,1.0,1.0,1.0);//vec4(1.0,0.6,0.3,1.0);
	vec4 damage_color_d = vec4(1.0,1.0,1.0,1.0);//vec4(1.0,1.0,1.0,1.0);
	vec4 damage_mix;
	vec4 damage_mix_b;
	vec2 outp;
	vec2 center = modf(noiseuv * frames,outp) - 0.45;
	float dist = distance(noiseuv, center) * 2.0;
	damage_mix = mix(damage_color_a,damage_color_b, 1.0 - dist);
	new_col = mix(original, damage_mix, (dist) * damage_strength);
	if(damage_strength > 0.75)
	{
		damage_mix_b = mix(damage_color_c,damage_color_d, (damage_strength - 0.75) * 4.0);
		new_col = mix(new_col, damage_mix_b, (damage_strength - 0.75) * 4.0);
	}
	new_col.a *= original.a;
	return new_col;
}

vec4 dissolve(vec4 original, vec2 uv, vec2 noiseuv) {

	vec4 new_col = original; // value that will be returned
	float noise = 0.0;

	float thickness = 0.5;
	float grad = 0.0;
	vec4 fire_grad;

	noise = fbm(noiseuv * 6.0);
	//noise = snoise(noiseuv * simplex_scale);
	//noise = 0.5 + 0.5 * sin(noise);

	if(dissolve_strength > noise && dissolve_strength <= noise + thickness * 0.5)
	{
		grad = clamp(2.0 * (dissolve_strength - noise) / (thickness),0.0,1.0);
		fire_grad = mix(dissolve_a, dissolve_b, grad);
		fire_grad = mix(new_col, fire_grad, grad);
		new_col = fire_grad;
	}
	if(dissolve_strength > noise + 0.5 * thickness && dissolve_strength < noise + thickness)
	{
		grad = clamp(2.0 * ((dissolve_strength - noise) / (thickness) - 0.5),0.0,1.0);
		fire_grad = mix(dissolve_b, dissolve_c, grad);
		fire_grad = mix(fire_grad, vec4(0.0), grad);
		new_col = fire_grad;
	}

	if(dissolve_strength >= noise + thickness)
	{
		new_col.a = 0.0;
	}
	new_col.a *= original.a;
	return new_col;
}

vec4 acid(vec4 original, vec2 uv, vec2 noiseuv, float time)
{
	vec2 coord = noiseuv * 6.0;
	vec4 new_col = original;

	float noise1 = fbm(coord + vec2(time * 0.03, time * 0.05));
	float noise2 = fbm(coord + vec2(0, time * -0.025));
	float combined = (noise1 + noise2) / 2.0;
	new_col = vec4(vec3(combined), 1.0);

	if (combined < acid_strength) {
		new_col = mix(acid_color_a, acid_color_b, acid_strength - combined);
		if(combined > acid_strength - 0.3)
		{
			new_col = mix(original, new_col,(acid_strength - combined) * 3.33);
		}
	} else {
		new_col = original;
	}
	new_col.a *= original.a;
	return new_col;
}

vec4 shock(vec4 original, vec2 uv, vec2 noiseuv, float time)
{
	vec2 coord = noiseuv * 8.0;
	vec4 new_col = original;

	float noise1 = fbm(coord + vec2(time * -0.3, time * 0.3));
	float noise2 = fbm(coord + vec2(0, time * -0.6));
	float combined = (noise1 + noise2) / 2.0;
	float shock_width = 0.175;
	float shock_input = shock_strength * 0.9 + 0.1;
	combined = pow(combined, shock_input);
	new_col = vec4(vec3(combined), 1.0);

	if (combined > 0.5 - shock_width && combined < 0.5 + shock_width) {
		if(combined < 0.5)
		{
			new_col = mix(shock_white, shock_color, (0.5 - combined) / shock_width);
			new_col = mix(new_col, original, (0.5 - combined) / shock_width);
		}
		if(combined > 0.5)
		{
			new_col = mix(shock_color, shock_white, 1.0 - (combined - 0.5) / shock_width);
			new_col = mix(original, new_col, 1.0 - (combined - 0.5) / shock_width);
		}
	} else {
		new_col = original;
	}
	new_col.a *= original.a;
	return new_col;
}

vec4 fire(vec4 original, vec2 uv, vec2 noiseuv, float time)
{
	vec2 coord = noiseuv * 10.0;
	vec4 new_col = original;

	float noise1 = fbm(coord + vec2(time * 0.3, time * -0.3));
	float noise2 = fbm(coord + vec2(0, time * 0.6));
	float combined = (noise1 + noise2) / 2.0;
	new_col = vec4(vec3(combined), 1.0);

	if (combined < fire_strength) {
		new_col = mix(fire_red, fire_yellow, fire_strength - combined);
		if(combined > fire_strength - 0.3)
		{
			new_col = mix(original, new_col, (fire_strength - combined) * 3.33);
		}
	} else {
		new_col = original;
	}
	new_col.a *= original.a;
	return new_col;
}

vec4 shield(vec4 original, vec2 texture_pixel_size, vec2 uv, sampler2D original_texture, float time)
{
	vec4 new_col;
	vec2 size = texture_pixel_size * shield_strength * 1.0 / 2.0;
	float l = texture(original_texture, uv + vec2(-size.x, 0)).a;
	float u = texture(original_texture, uv + vec2(0, size.y)).a;
	float r = texture(original_texture, uv + vec2(size.x, 0)).a;
	float d = texture(original_texture, uv + vec2(0, -size.y)).a;
	float lu = texture(original_texture, uv + vec2(-size.x, size.y)).a;
	float ru = texture(original_texture, uv + vec2(size.x, size.y)).a;
	float ld = texture(original_texture, uv + vec2(-size.x, -size.y)).a;
	float rd = texture(original_texture, uv + vec2(size.x, -size.y)).a;
	float vibrate = 5.0;
	vec4 color = original;
	float outline = min(1.0, l+r+u+d+lu+ru+ld+rd) - color.a;
	float inline = (1.0 - l * r * u * d * lu * ru * rd * ld) * color.a;

	vec4 outlined_result;
	vec4 shield_color;
	vec4 shield_color_mix;
	if(shield_charging > 0.0)
	{
		vibrate = 20.0;
	}
	shield_color = mix(shield_color_a,shield_color_b, 0.5 + 0.5 * sin(vibrate * time));
	shield_color.a = shield_color.a * 0.8 * shield_strength + 0.2;
	shield_color_mix = mix(shield_color, shield_damage_color, shield_damage_strength);
	outlined_result = mix(color, shield_color_mix, outline + inline);
	new_col = mix(color, outlined_result, outlined_result.a);
	return new_col;
}

vec4 selected(vec4 original, vec2 texture_pixel_size, vec2 uv, sampler2D original_texture)
{
	vec4 new_col;
	vec2 size = texture_pixel_size * select_strength * 1.0 / 2.0;
	float l = texture(original_texture, uv + vec2(-size.x, 0)).a;
	float u = texture(original_texture, uv + vec2(0, size.y)).a;
	float r = texture(original_texture, uv + vec2(size.x, 0)).a;
	float d = texture(original_texture, uv + vec2(0, -size.y)).a;
	float lu = texture(original_texture, uv + vec2(-size.x, size.y)).a;
	float ru = texture(original_texture, uv + vec2(size.x, size.y)).a;
	float ld = texture(original_texture, uv + vec2(-size.x, -size.y)).a;
	float rd = texture(original_texture, uv + vec2(size.x, -size.y)).a;
	vec4 color = original;
	float outline = min(1.0, l+r+u+d+lu+ru+ld+rd) - color.a;
	float inline = (1.0 - l * r * u * d * lu * ru * rd * ld) * color.a;

	vec4 outlined_result;

	outlined_result = mix(color, select_color, outline + inline);
	new_col = mix(color, outlined_result, outlined_result.a * select_strength);
	return new_col;
}

vec4 build(vec4 original, vec2 uv, vec2 noiseuv, vec2 texture_pixel_size, sampler2D original_texture)
{
	vec4 new_col = vec4(0.0,0.0,0.0,0.0);
	vec2 size = texture_pixel_size * 0.5 * 1.0 / 2.0;
	float l = texture(original_texture, uv + vec2(-size.x, 0)).a;
	float u = texture(original_texture, uv + vec2(0, size.y)).a;
	float r = texture(original_texture, uv + vec2(size.x, 0)).a;
	float d = texture(original_texture, uv + vec2(0, -size.y)).a;
	float lu = texture(original_texture, uv + vec2(-size.x, size.y)).a;
	float ru = texture(original_texture, uv + vec2(size.x, size.y)).a;
	float ld = texture(original_texture, uv + vec2(-size.x, -size.y)).a;
	float rd = texture(original_texture, uv + vec2(size.x, -size.y)).a;
	vec4 color = original;
	float outline = min(1.0, l+r+u+d+lu+ru+ld+rd) - color.a;
	float inline = (1.0 - l * r * u * d * lu * ru * rd * ld) * color.a;
	vec4 build_color = vec4(0.8,1.0,1.0,1.0);
	vec4 outlined_result;
	float linea = 0.0;

	if(build_strength > 0.7)
	{
		linea = 3.33 * (1.0 - build_strength) * 0.5;
	}
	else
	{
		linea = 0.5;
	}

	if(noiseuv.x * frames.x > 0.5 * build_strength && noiseuv.x * frames.x < 1.0 - 0.5 * build_strength)
	{
		if(noiseuv.x * frames.x < 0.5 * build_strength + 0.1)
		{
			new_col = mix(build_color, original,10.0 * (noiseuv.x * frames.x - build_strength * 0.5));
			new_col.a = new_col.a * original.a;
		}
		else if(noiseuv.x * frames.x > 1.0 - 0.5 * build_strength - 0.1)
		{
			new_col = mix(original, build_color, 10.0 * (noiseuv.x * frames.x + build_strength * 0.5 - 0.9));
			new_col.a = new_col.a * original.a;
		}
		else
		{
			new_col = original;
		}
	}
	else
	{
		new_col.a = 0.0;
		outlined_result = mix(vec4(0.0,0.0,0.0,0.0), build_color, outline + inline);
		new_col = mix(vec4(0.0,0.0,0.0,0.0), outlined_result, outlined_result.a * linea);
		/*if(outline + inline > 0.5)
		{
			new_col = vec4(1.0,0.0,0.0,1.0)
		}*/
	}
	return new_col;
}

vec2 swirl(vec2 uv, float t)
{
	//Work in Progress

	vec2 position = uv;
	vec2 center = vec2(0.5 / frames.x,0.5 / frames.y);
    float pi = 3.14;
    float distance_to_center = distance(position, center);
    float rotation_index = 60.0 * distance_to_center * pi * sin(swirl_strength/1.0) + 6.0 * swirl_strength;

    // move to (0.5, 0.5)
    //position -= vec2(0.5, 0.5);
	position -= vec2(0.5 / frames.x, 0.5 / frames.y);

    // apply rotation transformation
    mat2 rotation_matrix = mat2(vec2(cos(rotation_index), -sin(rotation_index)),
                                vec2(sin(rotation_index), cos(rotation_index)));
    position = position * rotation_matrix;

    // move back
    position += vec2(0.5 / frames.x, 0.5 / frames.y);
	if(position.x > 1.0 / frames.x)
	{
		position.x = 1.0/frames.x;
	}
	if(position.y > 1.0 / frames.y)
	{
		position.y = 1.0/frames.y;
	}
	if(position.x < 0.0 / frames.x)
	{
		position.x = 0.0/frames.x;
	}
	if(position.y < 0.0 / frames.y)
	{
		position.y = 0.0/frames.y;
	}
	return position;
}

vec4 burnt(vec4 original, float strength, float time)
{
	vec4 result;
	vec4 burnt_color = vec4(1.0,0.0,0.0,original.a);
	float dark_factor = 1.0;
	float burn_factor = 1.0;
	float time_shift = 1.0;

	dark_factor = 1.0 - 0.7 * (strength);
	if(strength >= 0.75)
	{
		time_shift = 5.0 * (strength - 0.75) + 0.5;
		burn_factor = 0.5 * (0.2 * sin(time * 2.0 * 3.141592 * time_shift) + 0.1 * (4.0 * (strength - 0.75)) - 0.1);
		if(burn_factor < 0.0)
		{
			burn_factor = 0.0;
		}
		result = mix(vec4(dark_factor * original.r, dark_factor * original.g, dark_factor * original.b, original.a),burnt_color,burn_factor);
	}
	else
	{
		result = vec4(dark_factor * original.r, dark_factor * original.g, dark_factor * original.b, original.a);
	}

	return result;
}

void fragment()
{
	vec4 current_texture;
	vec4 normal_texture;
	vec4 flag_mask_texture;
	vec4 lighting_texture;
	vec4 burn_texture;
	vec2 outp;
	vec2 noiseuv = UV;
	vec2 moduv = vec2(0,0);

	moduv = UV;
	if(cloak_strength != 0.0)
	{
		noiseuv = modf(noiseuv * frames, outp);
		noiseuv = noiseuv / frames;
		moduv.x = moduv.x + (.002 * cloak_strength) * sin(12.0 * TIME + 240.0 * noiseuv.y);
		moduv.y = moduv.y + (.0025 * cloak_strength) * cos(8.0 * TIME - 160.0 * noiseuv.x);
	}
	if(shield_damage_strength != 0.0)
	{
		noiseuv = modf(noiseuv * frames, outp);
		noiseuv = noiseuv / frames;
		moduv.x = moduv.x + (.0035 * shield_damage_strength) * sin(32.0 * TIME + 240.0 * noiseuv.y);
		moduv.y = moduv.y + (.0001 * shield_damage_strength) * cos(24.0 * TIME - 160.0 * noiseuv.x);
	}
	if(swirl_strength > 0.0)
	{
		noiseuv = modf(noiseuv * frames, outp);
		noiseuv = noiseuv / frames;
		moduv = UV - noiseuv + swirl(noiseuv,TIME);
	}
	noiseuv = moduv;
	noiseuv = modf(noiseuv * frames, outp);
	noiseuv = noiseuv / frames;

	current_texture = texture(TEXTURE,moduv);
	normal_texture = texture(NORMAL_TEXTURE,moduv);
	flag_mask_texture = texture(flag_mask,moduv);
	lighting_texture = texture(lighting,moduv);
	burn_texture = texture(burn,moduv);

	NORMAL_MAP = vec3(normal_texture[0], 1.0 - normal_texture[1],normal_texture[2]);
	if(flag_mask_texture.r > 0.5)
	{
		COLOR = current_texture * flag_color;
	}
	else
	{
		COLOR = current_texture;
	}
	if(burnt_strength > 0.0)
	{
		COLOR = burnt(COLOR, burnt_strength, TIME);
	}
	if(lighting_texture.r > .2f)
	{
		COLOR = lighting_texture * light_color * light_bright;
	}
	if(freeze_strength > 0.0)
	{
		COLOR = freeze(COLOR, moduv, noiseuv);
	}
	if(shield_strength > 0.0)
	{
		COLOR = shield(COLOR, TEXTURE_PIXEL_SIZE, moduv,TEXTURE, TIME);
	}
	if(burn_texture.r > .2f)
	{
		COLOR = COLOR + burn_texture * burn_color * burn_bright;
	}
	if(damage_strength > 0.0)
	{
		COLOR = damage(COLOR, moduv, noiseuv);
	}
	if(acid_strength > 0.0)
	{
		COLOR = acid(COLOR, moduv, noiseuv, TIME);
	}
	if(shock_strength > 0.0)
	{
		COLOR = shock(COLOR, moduv, noiseuv, TIME);
	}
	if(fire_strength > 0.0)
	{
		COLOR = fire(COLOR, moduv, noiseuv, TIME);
	}
	if(dissolve_strength > 0.0)
	{
		COLOR = dissolve(COLOR, moduv, noiseuv);
	}
	if(build_strength > 0.0)
	{
		COLOR = build(COLOR, moduv, noiseuv, TEXTURE_PIXEL_SIZE, TEXTURE);
	}
	if(select_strength > 0.0)
	{
		COLOR = selected(COLOR, TEXTURE_PIXEL_SIZE, moduv,TEXTURE);
	}
	if(cloak_strength > 0.0)
	{
		COLOR.a = COLOR.a * (1.0 - cloak_strength);
	}
}