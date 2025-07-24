shader_type sky;

uniform samplerCube cube_map;
//uniform int num_of_waves: hint_range(0, 10, 1);

float angle_between_vec2(vec2 a,vec2 b){
	return atan(a.x*b.y-a.y*b.x,a.x*b.x+a.y*b.y);
}

void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	
	//COLOR = vec3(SCREEN_UV.x,0.0,0.0);
	//COLOR = vec3(cos(TIME),sin(TIME),0.0);
	//if (SCREEN_UV.y >= 0.8-fract(TIME/10.0*SCREEN_UV.x)/30.0) COLOR = vec3(0.5);
	
	//if (SCREEN_UV.y >= sin(SCREEN_UV.x*TIME*2.0)) COLOR = vec3(0.5);
	//float height = 0.8 - sin(TIME) * SKY_COORDS.x;
	//if (SKY_COORDS.y >= height) COLOR = vec3(0.5);
	vec3 col = texture(cube_map,EYEDIR).rgb;
	//float a = angle_between_vec2(EYEDIR.xz,vec2(1.0,0.0)) + fract(TIME/50.0)*PI*2.0;
	float c = sin((SKY_COORDS.x+fract(TIME/PI/15.0))*PI*6.0);
	//if (SKY_COORDS.y >= sin(SKY_COORDS.x)) COLOR = vec3(0.5);
	//if (SKY_COORDS.y >= 0.5+sin(SKY_COORDS.x)/10.0) COLOR = vec3(0.5);
	
	int num_of_waves = 3;
	
	//if (SKY_COORDS.y >= 0.1 + c/60.0) COLOR = vec3(0.1);
	//if (SKY_COORDS.y >= 0.3 + c/50.0) COLOR = vec3(0.4);
	//if (SKY_COORDS.y >= 0.5 + c/40.0) COLOR = vec3(0.7);
	
	for (int i = 0;i < num_of_waves;i++){
		if (SKY_COORDS.y >= 0.17 + 0.5/float(num_of_waves)*float(i) + c/(100.0 - float(num_of_waves-i)*25.0)){
			COLOR = vec3(0.1+float(i)*(0.6/float(num_of_waves)));
		}
	}
	
	//COLOR = vec3(c);
	//COLOR = vec3(sin(SKY_COORDS.x/2.0));
}
