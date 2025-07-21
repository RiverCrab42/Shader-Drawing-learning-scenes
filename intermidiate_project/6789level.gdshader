shader_type canvas_item;
uniform sampler2D scr_tex :hint_screen_texture;
uniform vec2 player_pos;
varying vec2 player_pos_screen;
void vertex() {
	// Called for every vertex the material is visible on.
	player_pos_screen = (CANVAS_MATRIX*vec4(player_pos, 0.0, 1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = texture(scr_tex, SCREEN_UV+0.01*vec2(sin(TIME)));
	//vec2 pixel_size = SCREEN_PIXEL_SIZE;
	//vec3 scr_color_l = texture(scr_tex, SCREEN_UV-vec2(pixel_size.x,0.0)).rgb;
	//float gray_l = dot(scr_color_l, vec3(1.0-0.72-0.07, 0.72, 0.07));
	//vec3 scr_color_r = texture(scr_tex, SCREEN_UV+vec2(pixel_size.x,0.0)).rgb;
	//float gray_r = dot(scr_color_r, vec3(1.0-0.72-0.07, 0.72, 0.07));
	//
	//vec3 scr_color_u = texture(scr_tex, SCREEN_UV-vec2(0.0,pixel_size.y)).rgb;
	//float gray_u = dot(scr_color_u, vec3(1.0-0.72-0.07, 0.72, 0.07));
	//vec3 scr_color_d = texture(scr_tex, SCREEN_UV+vec2(0.0,pixel_size.y)).rgb;
	//float gray_d = dot(scr_color_d, vec3(1.0-0.72-0.07, 0.72, 0.07));
	//
	//COLOR = vec4(vec3(max(abs(gray_l-gray_r),abs(gray_u-gray_d))), 1.0);
	vec4 frag_coord = FRAGCOORD;
	
	COLOR = texture(scr_tex, SCREEN_UV);
	if (length(player_pos_screen-frag_coord.xy)<5.0)
	COLOR = vec4(1.0, 0.0, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
