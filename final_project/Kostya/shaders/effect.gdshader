shader_type spatial;
render_mode unshaded;
uniform float silaha: hint_range(0.0, 0.5, 0.01);
uniform float dirs: hint_range(0.0, 0.5, 0.01);
uniform vec2 centr = vec2(0.5,0.5);
uniform vec2 r1 = vec2(0.1,0.1);

uniform sampler2D scr_tex : hint_screen_texture, repeat_disable;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 pixel_size =1.0/viewport_size
	vec2 uv = SCREEN_UV;
	vec2 dir = vec2(uv.x - centr.x, uv.y - centr.y);
	vec2 offsd = silaha * dir * length(dir);
	float rr= texture(scr_tex, uv - offsd).r;
	float gg= texture(scr_tex, uv + offsd).g;
	float bb= texture(scr_tex, uv).b;
	vec3 vb=  vec3(rr,gg, bb);
	ALBEDO = vec3(rr,gg, bb);
	vec3 snt = mix(vb, vec3(0.0), 0.7);
	float t = sin(TIME) * 0.6 +0.5;
	if (distance(SCREEN_UV, centr) > 0.57) {
		ALBEDO = mix(vb, vec3(0.0), t);
	}
	//if (distance(SCREEN_UV, centr) > 0.6){
		//ALBEDO = mix(vec3(0.01,0.0,0.0), snt, t);
	//}
	
	 

	
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
