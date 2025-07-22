shader_type canvas_item;

uniform sampler2D scrTex : hint_screen_texture , repeat_enable;
uniform float scrollHor;
uniform float scrollVer;
uniform vec2 playerPos;

varying vec2 playerPosScreen;

void vertex() {
	playerPosScreen = (CANVAS_MATRIX * vec4(playerPos,0.0,1.0)).xy;
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(scrTex,SCREEN_UV);
	if (abs(scrollHor) > 0.0){
		COLOR = texture(scrTex,vec2(SCREEN_UV.x - scrollHor,SCREEN_UV.y));
	}
	if (abs(scrollVer) > 0.0){
		COLOR = texture(scrTex,vec2(SCREEN_UV.x,SCREEN_UV.y - scrollVer));
	}
	
	//vec2 pixelSize = SCREEN_PIXEL_SIZE;
	//vec3 scrColor_l = texture(scrTex,SCREEN_UV + vec2(pixelSize.x,0.0)).rgb;
	//float gray_l = dot(scrColor_l,vec3(1.0-0.72-0.07,0.72,0.07));
	//vec3 scrColor_r = texture(scrTex, SCREEN_UV - vec2(pixelSize.x,0.0)).rgb;
	//float gray_r = dot(scrColor_r,vec3(1.0-0.72-0.07,0.72,0.07));
	//
	//vec3 scrColor_up = texture(scrTex,SCREEN_UV + vec2(0.0,pixelSize.y)).rgb;
	//float gray_up = dot(scrColor_up,vec3(1.0-0.72-0.07,0.72,0.07));
	//vec3 scrColor_do = texture(scrTex, SCREEN_UV - vec2(0.0,pixelSize.y)).rgb;
	//float gray_do = dot(scrColor_do,vec3(1.0-0.72-0.07,0.72,0.07));
	//
	//COLOR = vec4(vec3(mix(abs(gray_l - gray_r),abs(gray_do - gray_up),0.5)*1.0),1.0);
	//COLOR = vec4(vec3(abs(gray_l - gray_r)),1.0);
	
	
	
	//vec4 fragCoord = FRAGCOORD;
	//
	//COLOR = texture(scrTex,SCREEN_UV);
	//if (length(playerPosScreen - fragCoord.xy) < 5.0){
		//COLOR = vec4(1.0,0.0,0.0,1.0);
	//}
	
	
	
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
