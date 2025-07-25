shader_type spatial;
render_mode unshaded;
uniform sampler2D scr_tex: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float px_size_x = 1.0/VIEWPORT_SIZE.x;
	float px_size_y = 1.0/VIEWPORT_SIZE.y;
	int blurSize = 4;
	float d = px_size_x * float(blurSize);
	float x_pixeliztion = SCREEN_UV.x;
	float y_pixeliztion = SCREEN_UV.y;
	vec4 sum = vec4(0.0,0.0,0.0,0.0);
	int c = 0;

	float minX;
	float minY;
	float prev = 0.0;
	for (float i = d; i < 1.0 + d/2.0; i+=d){
		if (x_pixeliztion <= i && x_pixeliztion >= prev) minX = prev;
		if (y_pixeliztion <= i && y_pixeliztion >= prev) minY = prev;
		prev = i;
	}
	vec4 newColor;
	for (int x = 0; x < blurSize;x++){
		for (int y = 0; y < blurSize;y++){
			float realX = minX + float(x)*px_size_x;
			float realY = minY + float(y)*px_size_y;
			sum += texture(scr_tex,vec2(realX,realY));
			c += 1;
		}
	}
	newColor = sum / float(c);

	ALBEDO = newColor.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
