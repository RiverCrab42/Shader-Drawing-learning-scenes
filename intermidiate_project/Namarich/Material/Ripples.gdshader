shader_type canvas_item;

uniform sampler2D scr_tex : hint_screen_texture;
uniform vec2 playerPos;

uniform vec4 baseColor: source_color;
uniform vec4 hihlightColor: source_color;
uniform float rippleRadius;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 pos = playerPos + 150.0;
	float r = length(pos) - (TIME * 0.5) * 0.5;
	float noiseVal2 = fract(r*2.0);
	vec4 texColor = texture(scr_tex,SCREEN_UV);
	
	vec4 rippleColor = mix(baseColor,hihlightColor,noiseVal2);
	vec4 col = mix(texColor,rippleColor,step(noiseVal2,SCREEN_UV.y+0.2));
	
	if (length(playerPos - FRAGCOORD.xy) <= rippleRadius){
		COLOR = col;
	}
	else{
		COLOR = texColor;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
