uniform sampler2D noise : repeat_enable;
uniform sampler2D gradient;


const vec4 RED = vec4(1., 0., 0., 1.);
const vec4 GREEN = vec4(0., 1., 0., 1.);
const vec4 BLUE = vec4(0., 0., 1., 1.);

mat2 rot_mat2(float angle) {
	return mat2(vec2(cos(angle), sin(angle)), vec2(-sin(angle), cos(angle)));
}

vec2 rotate_vec2(vec2 vec, float angle) {
	return vec * rot_mat2(angle);
}

mat3 move_mat3(vec2 _move) {
	return mat3(vec3(1., 0., _move[0]), vec3(0., 1., _move[1]), vec3(0, 0, 0));
}

vec2 move_vec2(vec2 vec, vec2 _move) {
	vec3 temp = vec3(vec, 1.) * move_mat3(_move);

	return vec2(temp[0], temp[1]);
}

mat3 rot_mat3(float A, float B, float C) {
	return mat3(
		vec3(cos(B) * cos(C), sin(A) * sin(B) * cos(C) + sin(C) * cos(A), sin(A) * sin(C) - sin(B) * cos(A) * cos(C)),
	 	vec3(-sin(C) * cos(B), -sin(A) * sin(B) * sin(C) + cos(A) * cos(C), sin(A) * cos(C) + sin(B) * sin(C) * cos(A)),
		vec3(sin(B), -sin(A) * cos(B), cos(A) * cos(B))
		);
}

vec3 rotate_vec3(vec3 vec, float A, float B, float C) {
	return vec * rot_mat3(A, B, C);
}

vec4 rotate_vec4_as_vec3(vec4 vec, float A, float B, float C) {
	return vec4(rotate_vec3(vec3(vec[0], vec[1], vec[2]), A, B, C), vec[3]);
}

vec2 rotate_vec2_as_vec3(vec2 vec, float A, float B, float C) {
	vec3 temp = rotate_vec3(vec3(vec, 0), A, B, C);
	return vec2(temp[0], temp[1]);
}

mat2 isometry_mat(vec2 _move, float A, float B, float C) {
	return mat2(transpose(rot_mat3(A, B, C)) * transpose(move_mat3(_move)));
}

vec4 _mix(vec4 a, vec4 b, float c) {
	return a * (1. - c) + b * c;
}

vec4 pixelize(float number_of_pixels, float size, vec2 uv, sampler2D tex) {
	vec2 pixel_coords = vec2(ivec2(floor(uv * number_of_pixels))) / number_of_pixels;
	
	vec4 color = vec4(0);
	int N = 0;
	
	for (float x = 0.; x <= 1. / number_of_pixels; x += 1. / size)
		for (float y = 0.; y <= 1. / number_of_pixels; y += 1. / size) {
			color += texture(tex, pixel_coords + vec2(x, y));
			N++;
		}
		
	return color / float(N);
}

vec4 grayscale(vec4 color) {
	float mean_color = color[0] * 0.21 + color[1] * 0.72 + color[2] * 0.07;
	
	return vec4(mean_color, mean_color, mean_color, color[3]);
}

vec4 colorscale(vec4 color, vec4 color1, vec4 color2) {
	float mean_color = color[0] * 0.21 + color[1] * 0.72 + color[2] * 0.07;
	
	return _mix(color1, color2, mean_color);
}

vec4 _noise(vec2 uv) {
	return texture(noise, uv);
}

float hash(vec2 vec) {
	vec4 temp = _noise(vec);
	
	return (temp[0] + temp[1] + temp[2] + temp[3]) / 4.;
}

float hash(float num) {
	return hash(vec2(floor(fract(num * 512.)) / 512., floor(num)));
}

float rand() {
	return hash(TIME);
}

vec4 _gradient(vec2 uv) {
	return texture(gradient, uv);
}

vec4 _gradient(float uv) {
	return _gradient(vec2(uv, 0.));
}

vec4 fire(vec2 uv, sampler2D tex) {
	float pixel_size = 1. / 128.;
	vec4 color = vec4(0.);
	
	for (float k = -pixel_size; k <= pixel_size; k += pixel_size)
		color += texture(tex, uv + vec2(k, pixel_size));
		
	return (color + texture(tex, uv)) / 4.;
}

mat4 move_mat4(vec3 moving) {
	return mat4(vec4(1., 0., 0., 0.),
				vec4(0., 1., 0., 0.),
				vec4(0., 0., 1., 0.),
				vec4(1., moving));
}

vec4 borders_mode(vec2 uv, sampler2D tex, vec2 screen_pixel_size) {
	vec4 contrast = max(texture(tex, uv + vec2(screen_pixel_size.x, 0.)), 
						texture(tex, uv + vec2(0., screen_pixel_size.y)));
	
	return vec4(vec3(length(texture(tex, uv) - contrast)), 1.);
}

bool near(vec2 first, vec2 second) {
	float EPSILON = 0.05;
	
	return length(first - second) <= EPSILON;
}