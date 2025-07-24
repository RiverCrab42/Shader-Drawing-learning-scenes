shader_type spatial;
render_mode unshaded;

uniform sampler2D noise : repeat_enable;
uniform sampler2D depth_tex : hint_depth_texture;
uniform sampler2D scr_tex : hint_screen_texture, repeat_disable;
uniform float foam : hint_range(0.0, 1.0, 0.1);
uniform float scr_shaking : hint_range(1.0, 100.0, 1.0);

void vertex() {

}

void fragment() {
	
	ALBEDO = vec3(0.0,0.0,1.0);
	
	float noise_val = (texture(noise,UV + TIME/5.0).x - 0.8) ;
	vec4 depth_tex_nds = texture(depth_tex, SCREEN_UV + noise_val / scr_shaking);
	vec4 depth_tex_ndsXY = vec4((SCREEN_UV.x + noise_val / scr_shaking) * 2.0 - 1.0, (SCREEN_UV.y + noise_val / scr_shaking) * 2.0 - 1.0, 0.0, 0.0);
	
	float noise_val_foam = (texture(noise,UV + TIME/5.0).x - 0.8) ;
	vec4 depth_tex_nds_foam = texture(depth_tex, SCREEN_UV );
	vec4 depth_tex_ndsXY_foam = vec4((SCREEN_UV.x ) * 2.0 - 1.0, (SCREEN_UV.y ) * 2.0 - 1.0, 0.0, 0.0);
	
	depth_tex_nds.z = depth_tex_nds.x;
	depth_tex_nds.xy = depth_tex_ndsXY.xy;
	depth_tex_nds_foam.z = depth_tex_nds_foam.x;
	depth_tex_ndsXY_foam.xy = depth_tex_ndsXY_foam.xy;
	vec4 depth_tex_v = INV_PROJECTION_MATRIX * depth_tex_nds;
	vec3 depth_view = depth_tex_v.xyz / depth_tex_v.w;
	float depth_lin = length(depth_view);
	vec4 nds_wall = vec4 (((SCREEN_UV) * 2.0 - 1.0), depth_tex_nds_foam.z, 1.0);
	vec4 view_wall = INV_PROJECTION_MATRIX * nds_wall;
	view_wall = view_wall / view_wall.w;
	vec3 water_v = VERTEX;
	vec3 camera_pos_v = vec3(0.0);
	float dist_water = length(-camera_pos_v + water_v);
	
	vec3 shaking = texture(scr_tex,vec2(SCREEN_UV.x + noise_val / scr_shaking, SCREEN_UV.y + noise_val / scr_shaking)).rgb;
	


	if(dot(NORMAL, normalize(water_v)) < -0.2){
			if(depth_lin - dist_water > 4.5){
				ALBEDO = mix(shaking,vec3(0.0,0.0,1.0),clamp(smoothstep(0.0,1.0,depth_lin/10.0),0.0,1.0));
			}
			else {
				ALBEDO = mix(shaking,vec3(0.0,0.0,1.0),smoothstep(0.0,0.7,dot(NORMAL, normalize(water_v))/1.0 +0.9));
			}
	}
		if((length(view_wall) - dist_water) < clamp(foam + noise_val * foam,0.0,1.0)){
			ALBEDO = vec3(1.0);
		}
}