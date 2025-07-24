shader_type spatial;
render_mode unshaded;

uniform sampler2D scrTex : hint_screen_texture;
uniform sampler2D NormalMap : hint_normal_roughness_texture;
uniform sampler2D DepthTex : hint_depth_texture;
uniform float PixelDep;


void vertex() {
	
	
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	mat3 GxMat = mat3(vec3(-1.0,-2.0,-1.0),vec3(0.0,0.0,0.0),vec3(1.0,2.0,1.0));
	mat3 GyMat = mat3(vec3(-1.0,0.0,1.0),vec3(-2.0,0.0,2.0),vec3(-1.0,0.0,1.0));
	
	
	
	vec2 pixSize = 1.0 / VIEWPORT_SIZE;
	vec3 color;
	float grayScale = 0.0;
	float Gx = 0.0;
	float Gy = 0.0;
	vec3 GxNor = vec3(0.0);
	vec3 GyNor = vec3(0.0);
	
	for (int y = 0; y < 3; y ++){
		for(int x = 0; x < 3; x ++){
			color = texture(scrTex,SCREEN_UV + vec2(float(x)*pixSize.x-pixSize.x,float(y)*pixSize.y-pixSize.y)).rgb;
			grayScale = dot(color, vec3(0.2122,0.722,0.07));
			Gx += GxMat[x][y]*grayScale;
			Gy += GyMat[x][y]*grayScale;
		}
	}
	
	for (int y = 0; y < 3; y ++){
		for(int x = 0; x < 3; x ++){
			color = texture(NormalMap,SCREEN_UV + vec2(float(x)*pixSize.x-pixSize.x,float(y)*pixSize.y-pixSize.y)).rgb;
			vec4 depth1 = INV_PROJECTION_MATRIX * vec4(0.0,0.0,texture(DepthTex, SCREEN_UV
				+ vec2(float(x)*pixSize.x-pixSize.x,float(y)*pixSize.y-pixSize.y)).r,1.0);
			GxNor += GxMat[x][y] * color;
			GyNor += GyMat[x][y] * color;
		}
	}
	
	float outline = sqrt(Gx*Gx + Gy*Gy) * 5.0 + sqrt(dot(GxNor,GxNor) + dot(GyNor,GyNor))/5.0;
	ALBEDO = vec3(step(0.2,outline));
	
	//ALBEDO = vec3(clamp(grayScale,0.0,1.0));
	//ALBEDO = texture(DepthTex,SCREEN_UV).rgb;
	//float intes = VIEWPORT_SIZE.x;
	//vec3 endColor = vec3(outline);
	//
	//for (float y = 0.0; y < 3.0*intes; y = y + intes){
		//for(float x = 0.0; x < 3.0*intes; x += intes){
			//endColor += texture(scrTex,SCREEN_UV + vec2(float(x)-intes,float(y)+intes)).rgb;
			//
		//}
	//}
	//mat4 sub = mat4(vec4(1.0/9.0,0.0,0.0,0.0),vec4(0.0,1.0/9.0,0.0,0.0),vec4(0.0,0.0,1.0/9.0,0.0),vec4(0.0,0.0,0.0,1.0/9.0));
	//COLOR = endColor*sub;
	
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
