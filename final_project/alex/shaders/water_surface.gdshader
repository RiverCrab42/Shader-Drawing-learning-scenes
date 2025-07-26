shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform sampler2D noise : repeat_enable;
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable;
uniform sampler2D scr_tex : hint_screen_texture, repeat_disable;
uniform float foam : hint_range(0.0, 1.0, 0.1);
uniform float scr_shaking : hint_range(1.0, 100.0, 1.0);
uniform float[2] woterspeed;
uniform float[2] xk;
uniform float[2] jxk;
uniform float[2] lkm;

void vertex() {
	VERTEX.y = cos(VERTEX.x*lkm[0] + VERTEX.z * xk[0] + TIME * woterspeed[0]) * jxk[0];
	VERTEX.y += sin(VERTEX.x*lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]) * jxk[1];
	float volna10 = lkm[0] * jxk[0] * sin( VERTEX.x * lkm[0] + VERTEX.z + xk[0] + TIME * woterspeed[0]);
	float volna11 = lkm[1] * jxk[1] * cos(VERTEX.x * lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]);
	float volna20 = xk[0] * jxk[0] * sin(VERTEX.x * lkm[0] + VERTEX.z * xk[0] + TIME * woterspeed[0]);
	float volna21 = xk[1] * jxk[1] * cos(VERTEX.x * lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]);
	//VERTEX.y = cos(VERTEX.x * woterspeed + TIME * xk) + cos(VERTEX.z * woterspeed + TIME * xk);
	NORMAL = normalize(vec3(volna10 - volna11, 1.0 , volna20 - volna21));
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


	if(dot(NORMAL, normalize(water_v)) < -0.05){
		vec3 fog_under = mix(shaking,vec3(0.0,0.0,1.0),clamp(smoothstep(0.0,1.0,depth_lin/10.0),0.0,1.0));
		vec3 fog_top = mix(shaking,vec3(0.0,0.0,1.0),smoothstep(0.0,0.7,dot(NORMAL, normalize(water_v))/1.0 +1.0));
		ALBEDO = mix(fog_under,fog_top,0.5);
		
			//if(depth_lin - dist_water > 4.5){
				//ALBEDO = mix(shaking,vec3(0.0,0.0,1.0),clamp(smoothstep(0.0,1.0,depth_lin/10.0),0.0,1.0));
			//}
			//else {
				//ALBEDO = mix(shaking,vec3(0.0,0.0,1.0),smoothstep(0.0,0.7,dot(NORMAL, normalize(water_v))/1.0 +0.9));
			//}
	}
		if((length(view_wall) - dist_water) < clamp(foam + noise_val * foam,0.0,1.0)){
			ALBEDO = mix(shaking,vec3(1.0),1.0);
		}
		
}