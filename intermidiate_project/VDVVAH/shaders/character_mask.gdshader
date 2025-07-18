shader_type canvas_item;

#include "res://VDVVAH/shaders/utils.gdshaderinc"

/**
* Sasha, do you implement your homework?
*/
uniform vec4 modulate_color : source_color;
uniform bool shield_exist;

varying float width;
varying float height;

void vertex() {
	COLOR = modulate_color;


}

void fragment() {
	if (shield_exist) {
		if (near(UV, vec2(0.5)))
			COLOR = vec4(1.);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
