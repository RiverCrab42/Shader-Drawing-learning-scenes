shader_type spatial;
render_mode cull_disabled;
global uniform vec3 player_pos_w;

uniform sampler2D tex : source_color;

instance uniform float x_l;
instance uniform float y_l;
instance uniform float z_l;
instance uniform float ugol_x;
instance uniform float ugol_y;
instance uniform float ugol_z;

uniform sampler2D noise;

float fade(float t) {
	return 6. * pow(t, 5.) - 15. * pow(t, 4.) + 10. * pow(t, 3.);
}
vec3 rotate_x(vec3 vector, float ugol){
	return (mat4(vec4(1.0, 0.0, 0.0, 0.0),
				vec4(0.0, cos(ugol), sin(ugol), 0.0),
				vec4(0.0, -sin(ugol), cos(ugol), 0.0),
				vec4(0.0, 0.0, 0.0, 1.0))*vec4(vector, 1.0)).xyz;
}
vec3 rotate_y(vec3 vector, float ugol){
	return (mat4(vec4(cos(ugol), 0.0, -sin(ugol), 0.0),
				vec4(0.0, 1.0, 0.0, 0.0),
				vec4(sin(ugol), 0.0, cos(ugol), 0.0),
				vec4(0.0, 0.0, 0.0, 1.0))*vec4(vector, 1.0)).xyz;
}
vec3 rotate_z(vec3 vector, float ugol){
	return (mat4(vec4(cos(ugol), sin(ugol), 0.0, 0.0),
				vec4(-sin(ugol), cos(ugol), 0.0, 0.0),
				vec4(0.0, 0.0, 1.0, 0.0),
				vec4(0.0, 0.0, 0.0, 1.0))*vec4(vector, 1.0)).xyz;
}

void vertex() {
	// Called for every vertex the material is visible on.
	float a = z_l * 0.01 * (-1.0);
	float b = y_l * 0.01;
	float c = x_l * 0.01;
	float dist_max = 7.0;
	float dist_min = 1.5;
	vec3 centr = vec3(0.0);
	vec3 centr_w = (MODEL_MATRIX*vec4(centr,1.0)).xyz;
	float dist = length(player_pos_w.xz - centr_w.xz);
	float dist_k = 1.0-(dist-dist_min)/(dist_max-dist_min);
	
	if (dist <= dist_min){
		VERTEX.z += centr.y;
		VERTEX.x += centr.z;
		VERTEX.y += centr.x;
		VERTEX = rotate_x(VERTEX, 0.0);
		VERTEX = rotate_y(VERTEX, 0.0);
		VERTEX = rotate_z(VERTEX, 0.0);
	}
	if (dist <= dist_max && dist > dist_min){
		VERTEX.z += mix(b, centr.y, fade(dist_k));
		VERTEX.x += mix(c, centr.z, fade(dist_k));
		VERTEX.y += mix(a, centr.x, fade(dist_k));
		VERTEX = rotate_x(VERTEX, mix(radians(ugol_x), 0.0, fade(dist_k)));
		VERTEX = rotate_y(VERTEX, mix(radians(ugol_y), 0.0, fade(dist_k)));
		VERTEX = rotate_z(VERTEX, mix(radians(ugol_z), 0.0, fade(dist_k)));
	}
	if (dist>dist_max){
		VERTEX.z += b;
		VERTEX.x += c;
		VERTEX.y += a;
		VERTEX = rotate_x(VERTEX, radians(ugol_x));
		VERTEX = rotate_y(VERTEX, radians(ugol_y));
		VERTEX = rotate_z(VERTEX, radians(ugol_z));
	}
}

void fragment() {
	float dist_max = 7.0;
	float dist_min = 1.5;
	vec3 centr = vec3(0.0);
	vec3 centr_w = (MODEL_MATRIX*vec4(centr,1.0)).xyz;
	float dist = length(player_pos_w.xz - centr_w.xz);
	float dist_k = 1.0-(dist-dist_min)/(dist_max-dist_min);
	// Called for every pixel the material is visible on.
	if (dist > dist_max)
		ALBEDO = (texture(tex, UV)).xyz;
	if (dist <= dist_max && dist >= dist_min)
		ALBEDO = (texture(tex, UV)).xyz + vec3(mix(0.0, 1.0, dist_k)*round(abs(sin(mix(1.0, 1000.0, dist_k)*TIME))), 0.0, 0.0);
	if (dist < dist_min)
		ALBEDO = (texture(tex, UV)).xyz;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
