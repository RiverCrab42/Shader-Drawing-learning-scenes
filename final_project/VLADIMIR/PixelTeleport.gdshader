shader_type spatial;
render_mode unshaded;

uniform sampler2D scrTex : hint_screen_texture;
uniform float stepPix = 1.0;
uniform bool start = false;
void vertex() {
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
}

void fragment() {
	int[4] massDirect = {0, 0, 0, 0};
	float pixNumX = (VIEWPORT_SIZE / stepPix*2.0).x;
	float pixNumY = (VIEWPORT_SIZE / stepPix*2.0).y;
	vec2 pos = vec2(floor(SCREEN_UV.x * pixNumX)/ pixNumX,floor(SCREEN_UV.y * pixNumY)/ pixNumY);
	float angle ;
	float grayScaleDir = 0.0;
	float grayScale = dot(texture(scrTex,pos).rgb,vec3(0.21,0.72,0.07));
	
	for (int x = 0; x < 8; x ++){
		for (int y = 0; y < 8; y ++){
			vec4 firstTex =  texture(scrTex,pos + 
				vec2(float(x),float(y))*(1.0/ VIEWPORT_SIZE));
			angle = firstTex.r;
			
			}
		}
	if (start){
		ALBEDO = mix(texture(scrTex,pos).rgb,vec3(0.0),stepPix/35.0);
	}
	else{
		ALBEDO = texture(scrTex,SCREEN_UV).rgb;
	}
	}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
