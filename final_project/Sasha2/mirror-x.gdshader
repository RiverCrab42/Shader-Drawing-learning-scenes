shader_type spatial;

instance uniform int tex_index;
uniform sampler2D tex_mirror_0;
uniform sampler2D tex_mirror_1;
uniform sampler2D tex_mirror_2;
uniform sampler2D tex_mirror_3;
uniform sampler2D tex_mirror_4;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	switch(tex_index) {
		case 0:
			ALBEDO = (texture(tex_mirror_0, vec2(UV.x, -UV.y))).xyz;
			break;
		case 1:
			ALBEDO = (texture(tex_mirror_1, vec2(UV.x, -UV.y))).xyz;
			break;
		case 2:
			ALBEDO = (texture(tex_mirror_2, vec2(UV.x, -UV.y))).xyz;
			break;
		case 3:
			ALBEDO = (texture(tex_mirror_3, vec2(UV.x, -UV.y))).xyz;
			break;
		case 4:
			ALBEDO = (texture(tex_mirror_4, vec2(UV.x, -UV.y))).xyz;
			break;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
