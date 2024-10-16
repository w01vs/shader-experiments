shader_type canvas_item;

uniform vec2 res;
uniform vec3 mouse;
uniform vec3 down = vec3(0.,1.,0.);
uniform int zoom;
uniform float DELTATIME;

void vertex() {
	// Called for every vertex the material is visible on.
}

// SDF for spheres
float sd_sphere(vec3 p, float s) {
	return length(p) - s;
}

//SDF for boxes
float sd_box(vec3 p, vec3 b)
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sd_plane(vec3 p, vec3 norm, float h) 
{ 
	return dot(p ,normalize(norm)) + h;
}

float sd_octahedron(vec3 p, float s) {
	p = abs(p);
	return (p.x + p.y +p.z - s) * 0.57735027;
}

float union(float d1, float d2) {
	return min(d1, d2);
}

float sub(float d1, float d2) {
	return max(-d1,d2);
}

float intersect(float d1 ,float d2) {
	return max(d1, d2);
}


// SDF
float map(vec3 p) {
	p.z += TIME * .4;
	
	
	p.xy = fract(p.xy) - .5;
	p.z = mod(p.z, .25) - .125;
	
	float box = sd_octahedron(p, .15);
	
	return box;
}

mat2 rot2d(float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return mat2(vec2(c , -s), vec2(s, c));
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
	return a + b * cos(6.28318*(c*t+d));
}

vec3 preset_palette(float t) {
	vec3 a = vec3(.5);
	vec3 b = vec3(.5);
	vec3 c = vec3(1.);
	vec3 d = vec3(.263, .416, .557);
	return palette(t, a, b, c, d);
}

void fragment() {
	
	// Called for every pixel the material is visible on.
	vec2 uv = (FRAGCOORD.xy * 2. - res.xy) / res.y;
	vec2 m = (mouse.xy *2. - res.xy) / res.y;
	// Initialization
	vec3 ray_origin = vec3(0,0,-3);
	vec3 ray_direction = normalize(vec3(uv.x, uv.y, 1.));
	vec3 out_color = vec3(0.);
	
	float t = 0.;
	
	//ray_origin += float(zoom) * vec3(0., 0., 1.);
	
	//ray_origin.yz *= rot2d(-m.y);
	//ray_direction.yz *= rot2d(-m.y);
	
	
	//ray_origin.xz *= rot2d(-m.x);
	//ray_direction.xz *= rot2d(-m.x);
	
	if (mouse.z < 0.) { m = vec2(cos(TIME*.2), cos(TIME*.2));}
	
	// Raymarching
	int i;
	for(int j = 0; i < 80;i++) {
		i = j;
		vec3 next_point = ray_origin + ray_direction * t;
		
		next_point.xy *= rot2d(t*.2 * m.x);
		next_point.y += sin(t*(m.y+1.)*.5) * .35;
		
		float d = map(next_point);
		
		t += d;
		
		
		if(d < .001) break;
		if(t > 100.) break;
	}
	
	out_color = preset_palette(t*.04 + float(i) * .005);
	
	COLOR = vec4(out_color, 1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
