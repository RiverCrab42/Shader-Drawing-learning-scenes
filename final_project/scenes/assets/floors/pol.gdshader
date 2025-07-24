shader_type spatial;

global uniform vec3 player_pos_w;

uniform sampler2D tex : source_color;

instance uniform float x_l;
instance uniform float y_l;
instance uniform float z_l;

uniform sampler2D noise;

float fade(float t) {
	return 6. * pow(t, 5.) - 15. * pow(t, 4.) + 10. * pow(t, 3.);
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
	}
	if (dist <= dist_max && dist > dist_min){
		VERTEX.z += mix(b, centr.y, fade(dist_k));
		VERTEX.x += mix(c, centr.z, fade(dist_k));
		VERTEX.y += mix(a, centr.x, fade(dist_k));
	}
	if (dist>dist_max){
		VERTEX.z += b;
		VERTEX.x += c;
		VERTEX.y += a;
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
