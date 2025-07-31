shader_type canvas_item;
uniform sampler2D mark_tex;
uniform int uron;
uniform int zdox;


void vertex() {

	if (zdox == 1)
		VERTEX = mat2(vec2(cos(TIME), sin(TIME)), vec2(-sin(TIME), cos(TIME))) * (VERTEX*(sin(TIME)/2.0+1.0));

}

void fragment() {
	// Called for every pixel the material is visible on.
	if (uron == 1)
		COLOR = texture(mark_tex, vec2(UV.x*10.0, UV.y)) + vec4(1.0,0.0,0.0,0.0);

	if (zdox == 0 && uron == 0)
		COLOR = texture(mark_tex, vec2(UV.x*10.0, UV.y));

	if (zdox == 1)
	COLOR = texture(mark_tex, vec2(UV.x*10.0, UV.y)) + vec4(sin(TIME)/2.0+0.5, cos(TIME*1.1)/2.0+0.5, sin(TIME*0.6)/2.0+0.5 , 1.52-TIME);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
