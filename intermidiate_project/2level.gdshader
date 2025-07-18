shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX = vec2(UV.x+128.0*cos(TIME), UV.y+128.0*sin(TIME));
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
