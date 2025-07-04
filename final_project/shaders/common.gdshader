shader_type spatial;

uniform sampler2D common_texture : filter_linear, source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = texture(common_texture, UV).xyz;
}

