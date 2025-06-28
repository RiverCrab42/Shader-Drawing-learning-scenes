shader_type canvas_item;

varying float color_r;
varying vec3 color;

void vertex() {
	color_r = (VERTEX.x + 64.0) / 128.0;
	color.r = (VERTEX.x + 64.0) / 128.0;
	color.g = (VERTEX.y + 64.0) / 128.0;
}

void fragment() {
	int a = 0;
	float b = 1.0;
	float[] array = {1.0, 20.0, 0.0};
						//r,   g,   b,   a
	vec4 red_color = vec4(1.0, 0.0, 0.0, 1.0);
	//COLOR.rbg = red_color.xxy;
	COLOR = texture(TEXTURE, UV);//vec4(UV, 0.0, 1.0);
	// Called for every pixel the material is visible on.
}