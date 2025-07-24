shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;
render_mode depth_draw_always;
uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 k = vec2(UV.x, UV.y+TIME/4.0);
	float h_min = -0.05;
	float h_max = 0.1;
	// Called for every pixel the material is visible on.
	//if (VERTEX.y > 0.0)
		//discard;
	vec3 VERTEX_l = (inverse(MODEL_MATRIX)*INV_VIEW_MATRIX*vec4(VERTEX, 1.0)).xyz;
	//if (VERTEX_l.y >= -0.2)
		//discard;
	if (VERTEX_l.y <= h_min){
		if (round(texture(noise, k).x) == 1.0)
			ALBEDO = vec3(1.0, 0.0, 0.0)+texture(noise, k).xyz * vec3(0.91, 0.4, 0.05);
		else
			ALBEDO = vec3(1.0, 0.0, 0.0)+texture(noise, k).xyz * vec3(0.89, 0.91, 0.05);
	}
	//TO DO: добавить discard для части фрагментов в диапозоне от h_min до h_max,
	//а также для всех фрагментов выше h_max
	if (VERTEX_l.y > h_min && VERTEX_l.y <= h_max){
		//TO DO: сделать так, чтобы сегменты отбрасывались чаще, в зависиости от того, 
		//насколько высоко они находятся. 
		if (round(texture(noise, k).x+1.5-(VERTEX_l.y-h_min)/(h_max-h_min)+VERTEX_l.y) == 1.0)
			discard;
		else
			//TO DO: сделать так, чтобы цвет сегмента менялся от желтого до красного (в зависимости от noise)
			//ALBEDO = vec3(1.0, 0.0, 0.0)+texture(noise, UV).xyz * vec3(0.91, 0.4, 0.05);
			if (round(texture(noise, k).x) == 1.0)
				ALBEDO = vec3(1.0, 0.0, 0.0)+texture(noise, k).xyz * vec3(0.91, 0.4, 0.05);
			else
				ALBEDO = vec3(1.0, 0.0, 0.0)+texture(noise, k).xyz * vec3(0.89, 0.91, 0.05);
	}
	if (VERTEX_l.y > h_max){
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
