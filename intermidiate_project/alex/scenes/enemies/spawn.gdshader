shader_type canvas_item;
uniform float pix : hint_range(1.0, 128.0, 1.0);
uniform sampler2D grad_tex;
uniform sampler2D noise : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

bool equals(float a, float b){
	if (abs(a-b)<0.01)
		return true;
	else{
		return false;
	}
}

void fragment() {
	float kletka = max(1.0/pix, 1.0 / 128.0);
	float j = floor(UV.y/kletka)*kletka;
	float i = floor(UV.x/kletka)*kletka;
	vec2 new_UV= vec2(i + 0.5 * kletka,j + 0.5 * kletka);
	float tex = texture(TEXTURE, new_UV).x;
	vec2 pos = new_UV * 2.0 - 1.0;
	float ang = atan(pos.y / pos.x);
	float r = length(pos) + TIME / 5.0;
	vec4 gt = texture(grad_tex, vec2((fract(r * 10.0))));
	COLOR = gt;


	if (tex < 0.1){
		COLOR = vec4(0.0);
	}


	//vec2 pos = UV * 2.0 - 1.0;
	//float ang = atan(pos.y, pos.x);
	//float radius = length(pos);
	//if (equals(radius,(ang+PI)/(2.0 * PI))){
		//COLOR = vec4(1.0);
	//}
	//float shape = abs(abs(tan( ang*1.0)) - radius);
	//float in_graph = 1.0 - smoothstep(0.05,0.1,shape);
	//COLOR = vec4(vec3(in_graph), 1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
