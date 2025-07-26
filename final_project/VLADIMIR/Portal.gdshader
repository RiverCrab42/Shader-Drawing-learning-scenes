shader_type spatial;
render_mode unshaded;
uniform float speed;
uniform float cutoff = 4.0;
uniform sampler2D color : source_color;
void vertex() {
	float x = VERTEX.x;
	float y = VERTEX.y;
	float angle = -TIME*speed ;
	VERTEX.xy = vec2(x*cos(angle)-y*sin(angle),y*cos(angle)+x*sin(angle));
	VERTEX.xy += vec2(sin(TIME*10.0),cos(TIME*10.0))/10.0;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 vertex_w = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	if (vertex_w.y > cutoff)
		discard;
	vec2 pos = 2.0*UV-1.0;
	if (length(pos) < 0.5 + sin(sin(TIME*2.0)*(UV.x+UV.y)*5.0)/10.0){
		ALBEDO = vec3(mix(vec3(0.0),texture(color,UV).rgb,length(pos)));
	}
	else{
		ALBEDO = texture(color,UV).rgb;
	}

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
