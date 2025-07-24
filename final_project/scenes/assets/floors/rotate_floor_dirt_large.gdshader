shader_type spatial;
uniform sampler2D noise;
void vertex() {
	// Called for every vertex the material is visible on.
	float u = 0.2*sin(TIME);
	VERTEX = ((mat4(vec4(cos(u),0.0,-sin(u), 0.0),
					vec4(0.0,1.0,0.0,0.0),
					vec4(sin(u),0.0,cos(u),0.0),
					vec4(0.0,0.0,0.0,1.0)))*(vec4(VERTEX*(cos(TIME)*0.5+1.0),1.0))).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(sin(TIME), 2.0*cos(TIME)-1.0, 1.5*sin(TIME)*cos(2.0*TIME));
	//ALBEDO = (texture(noise, UV)).xyz;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
