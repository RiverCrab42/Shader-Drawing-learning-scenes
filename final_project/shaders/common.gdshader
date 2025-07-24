shader_type spatial;
uniform sampler2D noise;
uniform sampler2D common_texture : filter_linear, source_color;
uniform vec3 ghost_pos_w;
void vertex() {
	// Called for every vertex the material is visible on.
	float dist_k = 5.0;
	vec3 VERTEX_w = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 dist = ghost_pos_w - VERTEX_w;
	if (length(dist)<=dist_k){
		float a = VERTEX.x+0.2*VERTEX.x*sin(VERTEX.x*sin(TIME)*72.0);
		float b = VERTEX.y+0.15*VERTEX.y*cos(VERTEX.y*sin(TIME)*52.0);
		float c = VERTEX.z+0.1*VERTEX.z*sin(VERTEX.z*cos(TIME)*82.0);
		VERTEX = vec3(a,b,c);//+NORMAL*(sin(TIME)-0.5)*0.004;
	}
}

void fragment() {
	float dist_k = 5.0;
	vec3 ghost_pos_v = (VIEW_MATRIX * vec4(ghost_pos_w, 1.0)).xyz;
	vec3 dist = ghost_pos_v - VERTEX;
	if (length(dist)<=dist_k){
		ALBEDO = vec3(0.0,0.5*sin(TIME)+0.5,0.0)*(texture(noise,UV)).xyz+(texture(common_texture, UV).xyz);
	}else
		ALBEDO = texture(common_texture, UV).xyz;
	// Called for every pixel the material is visible on.
}

