shader_type spatial;
render_mode unshaded;
//render_mode depth_draw_always;

//uniform sampler2D scrTex : hint_screen_texture;
uniform sampler2D scrTex : hint_screen_texture;
uniform sampler2D first_pass;
uniform sampler2D ASK;
uniform sampler2D Slash;
uniform int MinAgnleCount;
uniform float StepOutline;

//uniform float PixelDep;
//int ASCII(float inten){
	
//}
vec3 ASKI(float grave, vec2 pos){
	float graveStep = floor((1.0 - grave)*8.0);
	return texture(ASK,vec2(pos.x/8.0 + graveStep/8.0,pos.y)).rgb;
}
vec3 SLASH(int dir, vec2 pos){
	return texture(Slash,vec2(pos.x/4.0 + float(dir)/4.0,pos.y)).rgb;
}


void vertex() {
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	int[4] massDirect = {0, 0, 0, 0};
	
	float pixNumX = (VIEWPORT_SIZE / 8.0).x;
	float pixNumY = (VIEWPORT_SIZE / 8.0).y;
	vec2 pos = vec2(floor(SCREEN_UV.x * pixNumX)/ pixNumX,floor(SCREEN_UV.y * pixNumY)/ pixNumY);
	float angle ;//= texture(first_pass,pos).r;
	//
	//vec3 color = texture(first_pass,pos).rgb;
	float grayScaleDir = 0.0;
	float grayScale =  texture(first_pass,pos).b;
	for (int x = 0; x < 8; x ++){
		for (int y = 0; y < 8; y ++){
			vec4 firstTex =  texture(first_pass,pos + 
				vec2(float(x),float(y))*(1.0/ VIEWPORT_SIZE));
			angle = firstTex.r;
			if (firstTex.g > StepOutline){
				massDirect[int(angle*3.1)] += 1;
				ALBEDO = vec3(0.0);
			}
			grayScaleDir += firstTex.b;
		}
	}
	
	int indexMaxAngle = -1;
	int countMaxAngle = MinAgnleCount;
	for (int i = 0; i < 4; i ++){
		if (massDirect[i] > countMaxAngle){
			countMaxAngle = massDirect[i];
			indexMaxAngle = i;
		}
	}
	vec3 direct = vec3(0.0);
	if (indexMaxAngle > -1){
		ALBEDO = SLASH(indexMaxAngle,(-pos + SCREEN_UV)* vec2(pixNumX,pixNumY));
	}
	//if (indexMaxAngle < 0 && !optimisation){
		//ALBEDO =  ASKI(grayScaleDir/64.0, (-pos + SCREEN_UV)* vec2(pixNumX,pixNumY));
	//}
	if (indexMaxAngle < 0){
		ALBEDO =  ASKI(grayScaleDir/64.0, (-pos + SCREEN_UV)* vec2(pixNumX,pixNumY));
	}
	//ALBEDO = vec3(grayScaleDir / 64.0);
	//ALBEDO = vec3(grayScaleDir);
	//ALBEDO = vec3((-pos + SCREEN_UV) * vec2(pixNumX,pixNumY), 0.0);
	
	//ALBEDO = mix(vec3(0.0),vec3(1.0),floor(grayScale*16.0)/32.0);
	
	
	
	//ALBEDO = texture(scrTex, floor(vec2(SCREEN_UV.x*PixelDep,SCREEN_UV.y*PixelDep))/ PixelDep).rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
