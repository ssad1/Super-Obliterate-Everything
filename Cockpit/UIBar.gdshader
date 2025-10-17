shader_type canvas_item;

//Noise
uniform vec2 offset;
uniform float simplex_scale:hint_range(0.01, 1.0);
const int OCTAVES = 5;

//Fire
const vec4 fire_red = vec4(0.98, 0.18, 0.07, 1.0);
const vec4 fire_yellow = vec4(1.00, 0.84, 0.66, 1.0);
uniform float fire_strength = 0.0;
uniform float fire_height = 0.0;

//Shock
const vec4 shock_white = vec4(0.88, 0.97, 1.00, 1.00);
const vec4 shock_color = vec4(0.32, 0.78, 1.00, 1.00);
uniform float shock_strength = 0.0;
uniform float shock_height = 0.0;

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

vec4 shock(vec4 original, vec2 noiseuv, float time)
{
	original = vec4(0.16, 0.39, 0.5, 0.7);
	vec4 new_col = original;
	if(shock_height > noiseuv.x)
		{
		vec2 coord = noiseuv * 0.75;
		coord.y = coord.y / 20.0;
		coord = coord * vec2(5.0);
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
	}
	else
	{
		new_col = vec4(0.0,0.0,0.0,0.0);
	}
	return new_col;
}

vec4 fire(vec4 original, vec2 noiseuv, float time)
{
	original = vec4(0.15,0.15,0.15,0.7);
	vec4 new_col = original;
	if(fire_height > noiseuv.x)
	{
		vec2 coord = noiseuv * 1.0;
		coord.y = coord.y / 20.0;
		coord = coord * vec2(5.0);
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
	}
	else
	{
		new_col = vec4(0.0,0.0,0.0,0.0);
	}
	return new_col;
}

void fragment()
{
	float ratio = 0.0;
	
	ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
	
	COLOR = texture(TEXTURE,UV);
	if(shock_strength > 0.0)
	{
		COLOR = shock(COLOR, UV, TIME);
	}
	if(fire_strength > 0.0)
	{
		COLOR = fire(COLOR, UV, TIME);
	}
}