shader_type canvas_item;
uniform sampler2D gradienttx;

void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	float tex =texture(TEXTURE,UV).x;
	vec2 pos = UV * 2.0 - 1.0;
	float ang = atan(pos.y/ pos.x);
	float r = length(pos) + TIME/2.0;
	float bbc = fract(r * 10.0);
	vec4 gr = texture(gradienttx, vec2(bbc));
	COLOR = gr;
	if (tex < 0.1){
		COLOR= vec4(0.0);
	}
	// Called for every pixel the material is visible on.
}
	//float pos_len = length(pos);
	//float SHAPE = abs(abs(sin(ang) * 0.5)- pos_len);
	//float in_graph = 1.0 - smoothstep(0.11, 0.2, SHAPE);
	//COLOR = vec4(vec3(in_graph), 1.0);

	// Called for every pixel the material is visible on.

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
