shader_type spatial;
render_mode unshaded;

uniform sampler2D water_tex : filter_nearest, source_color, repeat_enable;

void vertex() {
}

void fragment() {
	ALBEDO = vec3(UV, 0.0);
	//ALBEDO = texture(water_tex, UV).xyz / 2.0;
	//ALPHA = 0.7;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
