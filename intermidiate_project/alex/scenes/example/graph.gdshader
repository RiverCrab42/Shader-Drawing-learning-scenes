shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float in_graph = 1.0 - smoothstep(0.05,0.1, abs(1.0 - UV.y - UV.x * UV.x) );
	COLOR = vec4(vec3(in_graph),1.0);
	
	//COLOR=vec4(vec3(smoothstep(0.3,0.7,UV.y)),1.0);
	//if (abs(1.0 - UV.y - UV.x * UV.x) < 0.003){
		//COLOR = vec4(1.0);
		//}
	//else{
	//COLOR = vec4(0.0,0.0,0.0,1.0);
		//}
}
	//COLOR = vec4(vec3(step(1.0 - UV.y,UV.x)),1.0);


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
