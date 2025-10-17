shader_type canvas_item;


//Noise
uniform vec2 offset;
const float simplex_scale = 0.05;
uniform vec2 scroll = vec2(0.0,0.0);

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
	float scale = 0.1;
	vec2 new_offset = offset;
	int OCTAVES = 5;

	for(int i = 0; i < OCTAVES; i++){
		value += snoise((coord + new_offset) * simplex_scale);
		coord *= 3.0;
		scale *= 0.75;
	}
	value = value / float(OCTAVES) + 0.5;
	value = clamp(value,0.0,1.0);
	return value;
}

vec4 shimmer(sampler2D original, vec2 uv, float time)
{
	vec2 coord = uv * 13.0;
	vec2 c_a;
	vec2 c_b;
	vec4 new_col;

	coord.x = coord.x * 1.777;
	c_a = coord - .025 * scroll;
	c_b = coord - .0125 * scroll;

	float noise1 = fbm(c_a + vec2(time * -0.100, time * 0.100));
	float noise2 = fbm(c_b + vec2(0, time * -0.033));
	float combined = pow((noise1 + noise2) / 2.0, 4.0);
	//new_col = vec4(vec3(combined),1.0);

	uv.y = uv.y + .1 * combined;
	new_col = texture(original,uv);
	//new_col = original * (.6 + .4 * (1.0 - combined));
	//new_col = vec4(1.0,1.0,1.0,1.0) * (1.0 - combined);
	//new_col = mix(original, smoke_color_b, combined);
	//new_col.a = combined;
	return new_col;
}

void fragment()
{
	vec4 current_texture;
	current_texture = texture(TEXTURE,UV);
	COLOR = current_texture;
	COLOR = shimmer(TEXTURE, UV, TIME);
}