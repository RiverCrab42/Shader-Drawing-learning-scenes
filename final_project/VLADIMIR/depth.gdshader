shader_type spatial;

uniform sampler2D depthTex : hint_depth_texture;
void vertex() {
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(depthTex,SCREEN_UV).rbb*40.0;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
