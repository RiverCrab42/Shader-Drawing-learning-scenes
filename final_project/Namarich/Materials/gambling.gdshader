shader_type sky;

uniform samplerCube cube_map;

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
	float a = angle_between_vec2(EYEDIR.xz,vec2(1.0,0.0)) + fract(TIME/50.0)*PI*2.0;
	//float b = SKY_COORDS.x + fract(TIME/50.0)*PI*2.0;
	//float b = sin(TIME)+SKY_COORDS.x;
	//float b = 0.8 - fract(TIME/50.0)*SKY_COORDS.x;
	//float b = sin(SKY_COORDS.x)/2.0+fract(TIME);
	if (SKY_COORDS.y >= sin(a)) COLOR = vec3(0.5);
	//COLOR = vec3(sin(a*3.0));
	//if (SKY_COORDS.y >= 0.4 && abs(sin(b*3.0)) >= 0.1) COLOR = vec3(0.5);
	//if (SKY_COORDS.y <= 0.4 && SKY_COORDS.y >= (sin(a*3.0)) + 0.1) COLOR = vec3(0.5);
}
