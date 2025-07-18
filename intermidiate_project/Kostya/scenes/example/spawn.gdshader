shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}
bool equals_f(float a, float b){
	if (abs(a-b) < 0.01) {
		return true;
	} else{
		return false;
	}
}
void fragment() {
	vec2 pos = UV * 2.0 - 1.0;
	float ang = atan(pos.x, pos.y);
	float radius = length(pos);
	if (equals_f(radius, (ang +PI) / (2.0 * PI))) {
		COLOR = vec4(1.0);
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
