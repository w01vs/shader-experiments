shader_type canvas_item;

uniform vec2 res;
uniform vec3 origin;
uniform vec2 rotation;
uniform vec3 down = vec3(0.,1.,0.);

void vertex() {
	// Called for every vertex the material is visible on.
}

// SDF for spheres
float sd_sphere(vec3 p, float s) {
	return length(p) - s;
}

//SDF for boxes
float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sd_plane(vec3 p, vec3 norm, float h) 
{ 
	return dot(p ,normalize(norm)) + h;
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
	vec3 sphere_pos = vec3(0., 0., 0.);
	float sphere = sd_sphere(p - sphere_pos, 1.);
	
	float box = sdBox(p, vec3(.75));
	
	float ground = sd_plane(p, vec3(0,-1,0), 1.);
	
	return union(ground, union(sphere, box));
}

mat3 rotate_y(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        vec3(c, 0.0, -s),
        vec3(0.0, 1.0, 0.0),
        vec3(s, 0.0, c)
    );
}

mat3 rotate_x(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, c, s),
        vec3(0.0, -s, c)
    );
}


void fragment() {
	
	// Called for every pixel the material is visible on.
	vec2 uv = (FRAGCOORD.xy * 2. - res.xy) / res.y;
	// Initialization
	vec3 ray_direction = normalize(vec3(uv.x, uv.y, 1.));
	vec3 out_color = vec3(0.);
	
	ray_direction = rotate_y(rotation.x) * rotate_x(-rotation.y) * ray_direction;
	float t = 0.;
	
	// Raymarching
	for(int i = 0; i < 80;i++) {
		vec3 next_point = origin + ray_direction * t;
		
		float d = map(next_point);
		
		t += d;
		
		
		if(d < .00001) break;
		if(t > 1000.) break;
	
	}
	
	out_color = vec3(float(t)) * .2;
	
	COLOR = vec4(out_color, 1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
