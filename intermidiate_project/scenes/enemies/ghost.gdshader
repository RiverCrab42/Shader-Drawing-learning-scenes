shader_type canvas_item;
instance uniform float die = 0.0;
uniform sampler2D noise: repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float noise_val = texture(noise, UV + TIME/4.0).x;
	COLOR = texture(TEXTURE, vec2(UV.x + noise_val / 600.0 , UV.y));
		float xz = texture(noise, UV + TIME/2.5).x;
	if ((die) > xz) {
		COLOR = vec4(0.0,0.0,0.0,0.0);
		}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
