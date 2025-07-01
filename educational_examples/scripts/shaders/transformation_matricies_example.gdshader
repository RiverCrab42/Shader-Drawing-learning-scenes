shader_type spatial;
render_mode unshaded;

//render_mode skip_vertex_transform;

const float scale = 1.2;
const mat4 scale_matrix = mat4(vec4(scale, 0.0, 0.0, 0.0),
							   vec4(0.0, scale, 0.0, 0.0),
							   vec4(0.0, 0.0, scale, 0.0),
							   vec4(0.0, 0.0, 0.0, 1.0));
const float r_x = -0.7;
const mat4 rotation_matrix_x = mat4(vec4(cos(r_x), 0.0, -sin(r_x), 0.0),
									vec4(0.0, 1.0, 0.0, 0.0),
									vec4(sin(r_x), 0.0, cos(r_x), 0.0),
									vec4(0.0, 0.0, 0.0, 1.0));
const float t_x = 1.0;
const float t_y = 1.0;
const float t_z = 0.5;
const mat4 transform = mat4(vec4(1.0, 0.0, 0.0, 0.0),
							vec4(0.0, 1.0, 0.0, 0.0),
							vec4(0.0, 0.0, 1.0, 0.0),
							vec4(t_x, t_y, t_z, 1.0));
void vertex() {
	//VERTEX = (scale_matrix * vec4(VERTEX, 1.0)).xyz;
	//VERTEX = (rotation_matrix_x * vec4(VERTEX, 1.0)).xyz;
	//VERTEX = (transform * vec4(VERTEX, 1.0)).xyz;
	//VERTEX = (transform * rotation_matrix_x * scale_matrix * vec4(VERTEX, 1.0)).xyz;

	//VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = vec3(0.5, 0.0, 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
