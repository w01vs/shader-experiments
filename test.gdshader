shader_type spatial;

uniform float d;
uniform float r;
uniform float s;

void vertex() {
	
	vec2 uv = vec2(UV.x, -UV.y);
	
	VERTEX.x += cos(TIME * s) * d * r;
	VERTEX.y += sin(TIME * s) * d * r;
	VERTEX.z += cos(TIME * s) * sin(TIME * s) * d * r;
}

void fragment() {
	
	vec2 pos = VERTEX.xy;
	
	vec4 tl = vec4(.5, .1, .9, 1.);
	vec4 tr = vec4(.3, 1., .8, 1.);
	vec4 bl = vec4(.8, .6, .1, 1.);
	vec4 br = vec4(.7, .1, .2, 1.);
	vec4 top = mix(tl, tr, pos.x);
	vec4 bot = mix(bl, br, pos.x);
	vec4 c = mix(top, bot , pos.y);
	ALBEDO = c.xyz;
	
	
	//ALPHA = c.a;
	
	//ALBEDO = vec3(1);
	
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
