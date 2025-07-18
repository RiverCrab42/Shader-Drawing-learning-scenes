shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//if(abs(1.0 - UV.y - UV.x * UV.x) < 0.02) {
		//COLOR = vec4(1.0);
		//
	//}
	//else {
		//COLOR = vec4(vec3(0.0),1.0);
	//}
	//COLOR = vec4(vec3(smoothstep(0.3,0.6,UV.y)), 1.0);
	float in_graph = 1.0 - smoothstep(0.07, 0.1, abs(1.0 - UV.y - UV.x * UV.x));
	COLOR = vec4(vec3(in_graph), 1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
