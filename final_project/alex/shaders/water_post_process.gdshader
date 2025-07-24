shader_type spatial;
render_mode unshaded;

uniform sampler2D noise : repeat_enable;
uniform sampler2D scr_tex : hint_screen_texture, repeat_disable;
uniform sampler2D depth_tex : hint_depth_texture;
uniform float scr_shaking : hint_range(1.0, 100.0, 1.0);
uniform vec3 fog_color : source_color;



void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	float noise_val = texture(noise,UV + TIME/5.0).x - 0.5;
	
	vec4 depth_tex_nds = texture(depth_tex, SCREEN_UV);
	vec4 depth_tex_v = INV_PROJECTION_MATRIX * depth_tex_nds.yzxw;
	float depth_lin = - depth_tex_v.z / depth_tex_v.w;

	float x =clamp(smoothstep(1.0,10.0,depth_lin),0.0,0.9);
	vec3 tex_color = texture(scr_tex,vec2(SCREEN_UV.x + noise_val / scr_shaking, SCREEN_UV.y + noise_val / scr_shaking)).rgb;
	vec3 shaking_fog = mix(tex_color,fog_color,x+0.1);
	ALBEDO = shaking_fog;
	//ALBEDO= depth_tex_nds.rgb;
	//ALBEDO = shaking_fog;
	
	//ALBEDO = texture(scr_tex, SCREEN_UV).rgb;
	//vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
