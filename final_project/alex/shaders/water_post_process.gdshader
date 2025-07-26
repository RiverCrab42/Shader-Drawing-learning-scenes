shader_type spatial;
render_mode unshaded;

uniform sampler2D noise : repeat_enable;
uniform sampler2D scr_tex : hint_screen_texture, repeat_disable;
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable;
uniform vec3 fog_color : source_color;
uniform float silaha: hint_range(0.0, 0.5, 0.01);
uniform vec2 centr = vec2(0.5,0.5);
uniform float scr_shaking : hint_range(0.0, 100.0, 1.0);
uniform float underwater_timer;
uniform float drown_time = 10.0;
uniform float drowning_start = 4.0;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {

	float noise_val = texture(noise,UV + TIME/5.0).x - 0.5;
	float noise_val_death = sin(texture(noise, UV + vec2(TIME * cos(PI/4.0)/15.0, TIME * sin(PI/4.0)/15.0))).x;
	float sh = noise_val / scr_shaking;
	vec2 uv = SCREEN_UV;
	vec2 dir = vec2(uv.x - centr.x, uv.y - centr.y);
	vec2 offsd = (silaha * dir * length(dir)) + sh;
	float rr= texture(scr_tex, uv - offsd).r + sh;
	float gg= texture(scr_tex, uv + offsd).g +sh;
	float bb= texture(scr_tex, uv).b + sh;
	ALBEDO = vec3(rr,gg, bb);

	float t = sin(TIME) * 0.6 + 0.5;
	vec3 sss =texture(scr_tex, vec2(UV.x + noise_val / 10.0 , UV.y + noise_val_death / 10.0)).rgb;
	if (distance(SCREEN_UV, centr) > 0.4 + noise_val_death/4.0) {
		ALBEDO = mix(sss, vec3(0.0), t);
	}
	vec3 vin = ALBEDO;


	vec4 depth_tex_nds = texture(depth_tex, SCREEN_UV + sh);
	vec4 depth_tex_ndsXY = vec4((SCREEN_UV.x + sh)* 2.0 - 1.0, (SCREEN_UV.y + sh) * 2.0 - 1.0, 0.0, 0.0);
	depth_tex_nds.z = depth_tex_nds.x;
	depth_tex_nds.xy = depth_tex_ndsXY.xy;
	vec4 depth_tex_v = INV_PROJECTION_MATRIX * depth_tex_nds;
	//float depth_lin = - depth_tex_v.z / depth_tex_v.w;
	vec3 depth_view = depth_tex_v.xyz / depth_tex_v.w;
	float depth_lin = length(depth_view);
	float x = clamp(smoothstep(1.0,10.0,depth_lin),0.0,0.9);
	vec3 tex_color = texture(scr_tex,vec2(SCREEN_UV.x + sh, SCREEN_UV.y + sh)).rgb;
	vec3 shaking_fog = mix(tex_color,fog_color,x+0.1);
	ALBEDO = shaking_fog;

	ALBEDO = mix(shaking_fog,vin,clamp((underwater_timer - drowning_start) * 0.5 / (drown_time - drowning_start), 0.0, 0.5));
	//ALBEDO = tex_color;

	//ALBEDO = texture(scr_tex, SCREEN_UV).rgb;
	//vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
