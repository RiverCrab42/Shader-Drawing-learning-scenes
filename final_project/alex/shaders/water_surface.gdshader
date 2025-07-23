shader_type spatial;
render_mode unshaded;

uniform sampler2D noise : repeat_enable;
uniform sampler2D depth_tex : hint_depth_texture;
uniform sampler2D normal_tex : hint_normal_roughness_texture;
uniform float foam : hint_range(0.0, 1.0, 0.1);

void vertex() {

}

void fragment() {
	
	ALBEDO = vec3(0.0,0.0,1.0);
	
	vec3 normal_tex2 = texture(normal_tex,SCREEN_UV).xyz;
	vec3 normal_v = normal_tex2 * 2.0 - 1.0;
	
	vec4 depth_tex_nds = texture(depth_tex, SCREEN_UV);
	vec4 nds_wall = vec4 ((SCREEN_UV * 2.0 - 1.0), depth_tex_nds.r, 1.0);
	vec4 view_wall = INV_PROJECTION_MATRIX * nds_wall;
	view_wall = view_wall / view_wall.w;
	vec3 water_v = VERTEX;
	vec3 camera_pos_v = vec3(0.0);
	float dist_water = length(-camera_pos_v + water_v);
	float noise_val = texture(noise,UV + TIME/5.0).x - 0.5;
	if((length(view_wall) - dist_water) < clamp(foam + noise_val * foam,0.0,1.0)){
		ALBEDO = vec3(1.0);
	}
	//ALBEDO = texture(normal_tex, SCREEN_UV).xyz;

	//ALBEDO = texture(depth_tex, SCREEN_UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
