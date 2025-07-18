shader_type canvas_item;
uniform sampler2D noise_texture;
uniform sampler2D scr_tex;
//uniform vec2 player_pos;
//varying vec2 player_pos_screen;

uniform float shakataka: hint_range(0.0, 0.1, 0.01);
uniform float skorost: hint_range(0.0, 50.0, 1.0);
uniform float freek: hint_range(0.0, 10.0, 1.0);

void vertex() {
	//player_pos_screen = (CANVAS_MATRIX * vec4(player_pos, 0.0, 0.1)).xy;
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 noise_scale = vec2(freek,freek);
	//vec2 noise_uv = UV * noise_scale + TIME * skorost;
	//vec2 noise = vec2(texture(noise_texture,noise_uv).r, texture(noise_texture,noise_uv).r);
	//noise = noise* 2.0 - 1.0;
	//vec2 uv_ofcey = noise * shakataka;
	//vec4 colorr = texture(TEXTURE,SCREEN_UV + uv_ofcey);
	//COLOR = colorr;
	
	vec2 pixel_size = SCREEN_PIXEL_SIZE;
	//
	vec3 scr_color_l = texture(scr_tex, SCREEN_UV - vec2(pixel_size.x, 1.0)).rgb;
	float gray_l = dot(scr_color_l, vec3(1.0- 0.72 - 0.07,0.72,0.07));
	vec3 scr_color_r = texture(scr_tex, SCREEN_UV + vec2(pixel_size.x, 0.0)).rgb;
	float gray_r = dot(scr_color_r, vec3(1.0- 0.72 - 0.07,0.72,0.07));
	vec3 scr_color_u = texture(scr_tex, SCREEN_UV - vec2(0.0,pixel_size.y)).rgb;
	float gray_u = dot(scr_color_u, vec3(1.0- 0.72 - 0.07,0.72,0.07));
	vec3 scr_color_d = texture(scr_tex, SCREEN_UV + vec2(0.0,pixel_size.y)).rgb;
	float gray_d = dot(scr_color_d, vec3(1.0- 0.72 - 0.07,0.72,0.07));
	float edge_value = abs(gray_l - gray_r) + abs(gray_u - gray_d);
	
	//COLOR = vec4(mix(vec3(edge_value), 0.8);
	
	COLOR = vec4(vec3(abs(gray_l - gray_r) + abs(gray_u - gray_d)), 0.8);
	// Called for every pixel the material is visible on.
	//vec4 frag_coord= FRAGCOORD;
	//COLOR = texture(scr_tex, SCREEN_UV);
	//if (length(player_pos_screen - frag_coord.xy) < 5.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
