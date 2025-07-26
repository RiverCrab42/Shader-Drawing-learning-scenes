shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;
render_mode depth_draw_always;
uniform sampler2D noise;
uniform vec3 color_red : source_color;
uniform vec3 color_yellow : source_color;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 k = vec2(UV.x, UV.y+TIME/4.0);
	float h_min = -0.12;
	float h_max = 0.1;
	
	vec3 VERTEX_l = (inverse(MODEL_MATRIX)*INV_VIEW_MATRIX*vec4(VERTEX, 1.0)).xyz;
	if (VERTEX_l.y <= h_min){
		if (round(texture(noise, k).x) == 1.0)
			ALBEDO = texture(noise, k).xyz * color_red;//vec3(0.91, 0.4, 0.05);
		else
			ALBEDO = texture(noise, k).xyz * color_yellow;////vec3(0.89, 0.91, 0.05);
	}

	if (VERTEX_l.y > h_min && VERTEX_l.y <= h_max){
		if (texture(noise, k).x+1.5-(VERTEX_l.y-h_min)/(h_max-h_min)+VERTEX_l.y <= 1.5)
			discard;
		else
			if (round(texture(noise, k).x) == 1.0)
				ALBEDO = texture(noise, k).xyz * color_red;
			else
				ALBEDO = texture(noise, k).xyz * color_yellow;
	}
	if (VERTEX_l.y > h_max){
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
