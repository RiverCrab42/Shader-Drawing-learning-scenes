shader_type canvas_item;

global uniform float HP;
global uniform float MAX_HP = 5.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float norm_HP = HP / MAX_HP;
	
	if (UV[0] <= norm_HP)
		COLOR = vec4(1., 0., 0., 1.);
	else
		COLOR = vec4(0.15, 0.15, 0.15, 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
