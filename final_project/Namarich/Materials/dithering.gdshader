shader_type spatial;

uniform sampler2D tex: source_color;

float grayScale(vec4 color){
	return dot(color.rgb,vec3(0.2126,0.7152,0.0722));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//TO DO: read from texture
	vec3 col = texture(tex,UV).rgb;
	ALBEDO.r = grayScale(vec4(col,1.0));
	ALBEDO.g = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
