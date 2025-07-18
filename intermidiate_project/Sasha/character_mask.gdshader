shader_type canvas_item;

global uniform float HP;
uniform sampler2D ghost_tex;
instance uniform float hit = 0.0;

uniform vec4 a_color : source_color;
uniform vec4 modulate_color : source_color;

vec2 rotate (vec2 vector, float ugol){
	return mat2(vec2(cos(ugol), sin(ugol)),vec2(-sin(ugol), cos(ugol)))*vector;
}

void vertex() {
	COLOR = modulate_color;
	if (hit>0.1 && HP>0.1) {
		VERTEX = rotate(VERTEX*42.0*TIME*sin(TIME)/(TIME+42.0), 42.0*TIME*pow(1.02, TIME)*tan(TIME));
		COLOR = a_color+vec4(tan(TIME),cos(TIME),sin(TIME),0.7);
	}
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (HP<=0.0) COLOR = texture(ghost_tex, UV/vec2(10.0,1.0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
