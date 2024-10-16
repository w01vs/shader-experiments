shader_type canvas_item;

uniform vec2 res;

void vertex() {
	// Called for every vertex the material is visible on.
}

// SDF
float map(vec3 point) {
	return length(point) - 1.;
}


void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = (FRAGCOORD.xy * 2. - res.xy) / res.y;
	// Initialization
	vec3 ray_origin = vec3(0., 0., -3.);
	vec3 ray_direction = normalize(vec3(uv, 1.));
	vec3 out_color = vec3(0.);
	
	float t = 0.;
	
	// Raymarching
	for(int i = 0; i < 80;i++) {
		vec3 next_point = ray_origin + ray_direction * t;
		
		float d = map(next_point);
		
		t += d;
		out_color = vec3(float(i)) / 80.;
		
		if(d < .00001) break;
		if(t > 1000.) break;
	
	}
	
	COLOR = vec4(out_color, 1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
