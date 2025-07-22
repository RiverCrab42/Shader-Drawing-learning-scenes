shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D rand : repeat_enable;
uniform float speed = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float ran = texture(rand,vec2(UV.x, UV.y + TIME * speed)).x;

	vec4 colorNoise = texture(noise,vec2(UV.x,UV.y + TIME));
	vec4 color = texture(TEXTURE,vec2(UV.x,UV.y));
	COLOR = mix(color,colorNoise,step(ran,UV.y)*step(ran,UV.x+0.7)*step(UV.x-0.7,ran));




	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
