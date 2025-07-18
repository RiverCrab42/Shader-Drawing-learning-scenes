shader_type canvas_item;
instance uniform float hit = 0.0;
/**
* Seva, a ti uroki sdelal?

 2+2=5
*/

uniform vec4 a_color : source_color;

vec2 rotate (vec2 vector, float ugol){
	return mat2(vec2(cos(ugol), sin(ugol)),vec2(-sin(ugol), cos(ugol)))*vector;
	}
void vertex() {
	// Called for every vertex the material is visible on.
	if (hit>0.1){
		VERTEX = rotate(VERTEX*TIME/(TIME*TIME+42.0), pow(1.02, TIME));
		COLOR = a_color+vec4(42.0,0.0,0.0,0.5);
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
