shader_type spatial;
render_mode unshaded;

uniform sampler2D water_tex : filter_nearest, source_color, repeat_enable;

void vertex() {
}

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.6);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
