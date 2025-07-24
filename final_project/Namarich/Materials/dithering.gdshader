shader_type spatial;
render_mode shadow_to_opacity;

uniform sampler2D tex: source_color;

float grayScale(vec4 color){
	return dot(color.rgb,vec3(0.2126,0.7152,0.0722));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 col = texture(tex,UV).rgb;
	ALBEDO.r = grayScale(vec4(col,1.0));
	ALBEDO.g = 0.0;
	ALBEDO.b = 1.0;
}

// + 0.25 надо чтобы было по-красивше
void light(){
	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ATTENUATION * clamp(dot(LIGHT,NORMAL)+0.25,0.0,1.0);
}
