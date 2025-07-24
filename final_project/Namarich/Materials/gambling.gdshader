shader_type sky;

uniform samplerCube cube_map;
//uniform int num_of_waves: hint_range(0, 10, 1);

float angle_between_vec2(vec2 a,vec2 b){
	return atan(a.x*b.y-a.y*b.x,a.x*b.x+a.y*b.y);
}

void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	vec3 col = texture(cube_map,EYEDIR).rgb;
	float c = sin((SKY_COORDS.x+fract(TIME/PI/15.0))*PI*6.0);
	int num_of_waves = 3;
	
	for (int i = 0;i < num_of_waves;i++){
		if (SKY_COORDS.y >= 0.32 + 0.5/float(num_of_waves)*float(i) + c/(100.0 - float(num_of_waves-i)*25.0)){
			COLOR = vec3(0.1+float(i)*(0.6/float(num_of_waves)));
		}
	}
}
