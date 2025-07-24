shader_type spatial;
render_mode unshaded;
uniform sampler2D scrTex : hint_screen_texture;
uniform sampler2D depTex : hint_depth_texture;

void vertex() {
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 BlockSize = VIEWPORT_SIZE / 8.0;
	mat3 GxMat = mat3(vec3(-1.0,-2.0,-1.0),vec3(0.0,0.0,0.0),vec3(1.0,2.0,1.0));
	mat3 GyMat = mat3(vec3(-1.0,0.0,1.0),vec3(-2.0,0.0,2.0),vec3(-1.0,0.0,1.0));
	vec2 pixSize = 1.0 / VIEWPORT_SIZE;
	//float pixNumX = BlockSize.x;
	//float pixNumY = BlockSize.y;
	float Gx = 0.0;
	float Gy = 0.0;
	float grayScale = 0.0;
	vec3 color;
	//vec2 pos = vec2(floor(SCREEN_UV.x * pixNumX)/ pixNumX,floor(SCREEN_UV.y * pixNumY)/ pixNumY);
	for (int y = 0; y < 3; y++){
		for (int x = 0; x < 3; x++){
			color = texture(scrTex,SCREEN_UV + vec2(float(x)*pixSize.x-pixSize.x,
									float(y)*pixSize.y-pixSize.y)).rgb;
			grayScale = dot(color,vec3(0.21,0.72,0.07));
			Gx += GxMat[x][y] * grayScale;
			Gy += GyMat[x][y] * grayScale;
		}
		
	}
	float angle;
	if (abs(Gx) > 2.0*abs(Gy) || abs(Gy) > 2.0*abs(Gx)){
		if (abs(Gx) > 2.0*abs(Gy)){
			angle = 0.0;
		}
		if (abs(Gy) > 2.0*abs(Gx)){
			angle = 0.66;
		}
	}
	else {
		if (Gx*Gy > 0.0){
			angle = 0.33;
		}
		if (Gx*Gy < 0.0){
			angle = 1.0;
		}
	}
	float outline = sqrt(Gx*Gx+Gy*Gy);
	ALBEDO = vec3(angle,outline,grayScale); //* (INV_PROJECTION_MATRIX * texture(depTex,SCREEN_UV)).r * 10.0);
	
	
	
	
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
