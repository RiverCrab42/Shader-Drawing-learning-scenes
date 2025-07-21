shader_type canvas_item;
instance uniform float a;
uniform vec4 a_color : source_color;
vec2 rotate (vec2 vector, float ugol){
	return mat2(vec2(cos(ugol), sin(ugol)),vec2(-sin(ugol), cos(ugol)))*vector;
}
void vertex() {
	if (a>0.1){
		VERTEX = rotate(VERTEX*sin(TIME), 42.0*sin(TIME));
		COLOR = a_color;
	}
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(vec3(0.0, 255.0*sin(4.0*TIME)+1.0, 0.0),1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
