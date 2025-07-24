shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
		float u = sin(TIME);
	VERTEX = ((mat4(vec4(cos(42.0*u),0.0,-sin(2.0*u), 0.0),
					vec4(0.0,1.0,cos(u),0.0),
					vec4(sin(u*1.42),0.0,cos(3.0*u),0.0),
					vec4(0.0,0.0,0.0,1.0)))*(vec4(VERTEX*(cos(TIME)*2.0+2.0),1.0))).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(sin(TIME)*sin(TIME),1.42*sin(TIME),cos(sin(TIME)));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
