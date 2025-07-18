shader_type canvas_item;

instance uniform float loading = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 circles(vec2 uv) {
	vec4 color1 = vec4(1., 0., 0., 1.);
	vec4 color2 = vec4(0., 0., 1., 1.);
	
	if (length(uv - vec2(0.5)) < 0.5)
		return mix(color1, color2, (fract(length(uv - vec2(0.5)) * sin(loading) * 16. * loading)));
	else
		return vec4(0.);
}

#define sampler circles
vec4 pixelize(float number_of_pixels, float size, vec2 uv) {
	vec2 pixel_coords = vec2(ivec2(floor(uv * number_of_pixels))) / number_of_pixels;
	
	vec4 color = vec4(0);
	int N = 0;
	
	for (float x = 0.; x <= 1. / number_of_pixels; x += 1. / size)
		for (float y = 0.; y <= 1. / number_of_pixels; y += 1. / size) {
			color += sampler(pixel_coords + vec2(x, y));
			N++;
		}
		
	return color / float(N);
}

void fragment() {
	COLOR = mix(pixelize(32., 300., UV), texture(TEXTURE, UV), length(UV - vec2(0.5)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
