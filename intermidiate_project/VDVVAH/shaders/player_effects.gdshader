shader_type canvas_item;

#include "utils.gdshaderinc"

global uniform float HP;
global uniform float MAX_HP;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D damage_effect;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = mix(borders_mode(SCREEN_UV, screen_texture, SCREEN_PIXEL_SIZE),
				texture(screen_texture, SCREEN_UV),
				HP / MAX_HP);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
