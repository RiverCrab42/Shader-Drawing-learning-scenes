shader_type spatial;

uniform float persistance = 0.25;
uniform float number_of_octaves = 1.;


float _rand_function1(ivec2 vertex) {
	return fract(sin(dot(vec2(vertex), vec2(12.9898, 43.29))) * 45000.928);
}

float _rand_function2(ivec2 vertex) {
	int n = vertex.x + 57*vertex.y;
	n = (n << 13) ^ n;
	return 1.0 - float(n* (n*n*41+527482) & int (pow(2.0, 31.0))) / pow(2.0, 30.0);
}

vec2 _rand_vec_function(ivec2 vertex) {
	return normalize(vec2(_rand_function1(vertex), _rand_function2(vertex)));
}

float fade(float x) {
	return 6. * pow(x, 5.) - 15. * pow(x, 4.) + 10. * pow(x, 3.);
}

float mixer(float a, float b, float c) {
	return mix(a, b, fade(c));
}

float _rand_function_interpolation(vec2 args) {
	ivec2 lt_vertex_pos = ivec2(floor(args));
	vec2 local_pos = fract(args);

	vec2 vertex1 = vec2(lt_vertex_pos);
	vec2 vertex2 = vertex1 + vec2(0., 1.);
	vec2 vertex3 = vertex1 + vec2(1., 0.);
	vec2 vertex4 = vertex1 + vec2(1.);

	//#define vertex_value(index) dot(_rand_vec_function(ivec2(vertex##index)), args - vertex##index)
	#define vertex_value(index) _rand_function1(ivec2(vertex##index))


	float h1_interpolation = mixer(vertex_value(1), vertex_value(2), local_pos.y);
	float h2_interpolation = mixer(vertex_value(3), vertex_value(4), local_pos.y);
	float interpolation = mixer(h1_interpolation, h2_interpolation, local_pos.x);

	return interpolation;
}

float _rand_function_interpolation(vec2 args, float num) {
	return _rand_function_interpolation(args * num);
}

float _terrain(vec2 args) {
	return _rand_function_interpolation(args);
}

float _terrain_iterated(vec2 args) {
	float sum = 0., c;

	for (float k = 0.; k < number_of_octaves; k++) {
		sum += _terrain(args * pow(2, k)) * pow(persistance, k);
	}

	return sum;
}

float _generate_terrain(vec2 args) {
	//return sin(args.x+args.y) + cos(args.y);
	return _terrain_iterated(args);
}

vec3 _normal_of_terrain(vec3 args) {
	float EPSILON = 0.001;
	float value = args.y;

	return normalize(-cross(
				vec3(EPSILON, _generate_terrain(args.xz + vec2(EPSILON, 0.)) - value, 0.),
				vec3(0., _generate_terrain(args.xz + vec2(0., EPSILON)) - value, EPSILON)));
}


void vertex() {
	vec3 vertex_w = (MODEL_MATRIX * vec4(VERTEX, 1.)).xyz;
	VERTEX.y = _generate_terrain(vertex_w.xz);
}

void fragment() {
	vec3 vertex_w = (INV_VIEW_MATRIX * vec4(VERTEX, 1.)).xyz;

	vertex_w.y = _generate_terrain(vertex_w.xz);
	float eps = 0.0001;
	vec3 normal = _normal_of_terrain(vertex_w);

	NORMAL = (VIEW_MATRIX * vec4(normal, 0.)).xyz;
	//vec2 debug;
	//
//
	//ALBEDO = vec3(_generate_terrain(vertex_w.xz, 10.));

	//if (debug.x > 0.99)
		//ALBEDO = vec3(1., 0., 0.);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
