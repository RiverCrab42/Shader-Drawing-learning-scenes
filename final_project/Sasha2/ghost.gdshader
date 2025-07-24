shader_type spatial;
uniform sampler2D ghost_tex;
instance uniform bool see;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if (see == true)
		ALBEDO = (texture(ghost_tex, UV)).xyz + vec3(abs(sin(42.0*TIME)), 0.0, 0.0);
	else
		ALBEDO = (texture(ghost_tex, UV)).xyz;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
