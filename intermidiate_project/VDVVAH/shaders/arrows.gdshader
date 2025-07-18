shader_type canvas_item;

uniform float number_of_arrows = 5.;
uniform sampler2D arrow: repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = (UV[0] < number_of_arrows / 5.) ? texture(arrow, vec2(UV[0] * 5., UV[1])): vec4(0.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
