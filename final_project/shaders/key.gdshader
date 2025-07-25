shader_type spatial;

instance uniform vec4 modulate_color : source_color;
instance uniform float pick = 0.0 ;
uniform sampler2D noise : repeat_enable;
uniform sampler2D scr_tex : hint_screen_texture;


void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.4);
	float x = texture(noise, UV).x;
	
	if (pick > x){
		discard;
	}
	else if (pick > x - 0.1){
		ALBEDO = vec3(0.2);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
