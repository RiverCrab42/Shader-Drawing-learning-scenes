shader_type canvas_item;
instance uniform float hit = 0.0;
uniform vec4 a_color : source_color;

vec2 rotate (vec2 vector, float ugol){
	return mat2(vec2(cos(ugol), sin(ugol)),vec2(-sin(ugol), cos(ugol)))*vector;
}
void vertex() {
	if (hit > 0.1) {
		VERTEX = rotate(VERTEX*sin(TIME), 42.0*sin(TIME));
		COLOR = a_color;
		
	
		//Some code here
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(vec3(180.0*sin(2.0*TIME), 250.0*sin(3.0*TIME)*cos(1.5*TIME), 190.0*cos(TIME)), sin(0.1*TIME))*texture(TEXTURE, UV)*texture(TEXTURE, UV)*texture(TEXTURE, UV)+texture(TEXTURE, UV)*texture(TEXTURE, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
