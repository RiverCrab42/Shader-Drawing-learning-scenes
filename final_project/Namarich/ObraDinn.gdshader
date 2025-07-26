shader_type spatial;
render_mode unshaded;

uniform sampler2D scr_tex: hint_screen_texture;

uniform sampler2D blue_noise : repeat_enable, filter_nearest;

uniform float cc : hint_range(10.0, 30.0, 0.5);

uniform vec3 dark_color: source_color;
uniform vec3 bright_color: source_color;
uniform vec3 outline_color: source_color;

uniform float FOV;
uniform float pixelization_size;

uniform sampler2D normal_tex: hint_normal_roughness_texture;
uniform sampler2D depth_tex: hint_depth_texture;

uniform float count_color: hint_range(1.0, 10.0, 0.1);
uniform float tresh_hold_n : hint_range(0.0, 1.0, 0.01);
uniform float tresh_hold_d : hint_range(0.0, 1.0, 0.01);
uniform float coff : hint_range(0.0, 10.0, 0.01);


vec3 texel_fetch(sampler2D tex, vec2 size, vec2 coord){
	float x = fract(coord.x/size.x) * size.x;
	float y = fract(coord.y/size.y) * size.y;
	return texelFetch(tex, ivec2(int(x), int(y)), 0).rgb;
}

float angle_between_vec2(vec2 a,vec2 b){
	return atan(a.x*b.y-a.y*b.x,a.x*b.x+a.y*b.y);
}

float grayScale(vec4 color){
	return dot(color.rgb,vec3(0.2126,0.7152,0.0722));
}

float linear_depth2(float d,mat4 inv){
	vec4 f = inv * vec4(0.0,0.0,d,1.0);
	float z_lin = f.z/f.w;
	return -z_lin;
}

vec3 linear_depth(mat4 M, vec2 SUV, vec2 shift){
	vec4 v = M * vec4((vec2(SUV.x, SUV.y) + vec2(shift.x, shift.y))*2.0-1.0, texture(depth_tex, SUV + shift).r, 1.0);
	return v.xyz/v.w;
}

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.x,VERTEX.y,1.0,1.0);
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	float px_size_x = 1.0/VIEWPORT_SIZE.x;
	float px_size_y = 1.0/VIEWPORT_SIZE.y;

	mat3 Gx = mat3(vec3(-1, -2, -1), vec3(0, 0, 0), vec3(1, 2, 1));
	mat3 Gy = mat3(vec3(-1, 0, 1), vec3(-2, 0, 2), vec3(-1, 0, 1));
	float Gxx = 0.0;
	float Gyy = 0.0;
	
	for(int i=0; i<3; i++){
		i *= int(pixelization_size);
		vec3 a = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(-px_size_x,  float(i-1)*px_size_y)*coff);
		vec3 b = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(px_size_x, float(i-1)*px_size_y)*coff);
		vec3 normal = texture(normal_tex, vec2(SCREEN_UV.x + px_size_x, SCREEN_UV.y + float(i-1)*px_size_y)).xyz *2.0 -1.0;
		i /= int(pixelization_size);
		if(a.z < -1000.0){
				Gxx +=0.0;
			}
		else
		
		Gxx += dot(a-b, normal) * Gx[0][i];
		
	}
	for(int i=0; i<3; i++){
		i *= int(pixelization_size);
		vec3 a = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(float(i-1)*px_size_x, - px_size_y)*coff);
		vec3 b = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(float(i-1)*px_size_x, px_size_y)*coff);
		vec3 normal = texture(normal_tex, vec2(SCREEN_UV.x + float(i-1)*px_size_x, SCREEN_UV.y + px_size_y)).xyz * 2.0 - 1.0;
		i /= int(pixelization_size);
		if(a.z < -1000.0){
			Gyy +=0.0;
			
		}
		else
			Gyy += dot(a-b, normal) * Gy[i][0];
	}
	float grey_d = step(tresh_hold_d, sqrt(pow(Gxx, 2)+ pow(Gyy, 2)));
	
	vec3 v1 = texture(normal_tex, SCREEN_UV + vec2(-px_size_x, -px_size_y)).rgb;
	Gxx = 0.0;
	Gyy=0.0;
	for(float j=-1.0; j<=1.0; j++){
		for(float i=-1.0; i<=1.0; i++){
			
			float j2 = j * pixelization_size;
			float i2 = i * pixelization_size;
			
			vec2 shift_pixels = vec2(px_size_x * i2, px_size_y*j2)*coff;
			vec3 normal = texture(normal_tex, SCREEN_UV + shift_pixels).xyz;
			
			float gray_scale_n = distance(normal, v1);
			
			float gray_scale =  gray_scale_n;
			Gxx += gray_scale * Gx[int(j)+1][int(i)+1];
			Gyy += gray_scale * Gy[int(j)+1][int(i)+1];
			
			v1 = texture(normal_tex, SCREEN_UV + shift_pixels).rgb;
		}
	}
	float albedo = 1.0 - clamp(grey_d +step(tresh_hold_n, sqrt(pow(Gxx, 2) + pow(Gyy, 2))*1.0), 0.0, 1.0);
	float color_grey = dot(texture(scr_tex, SCREEN_UV).rgb, vec3(0.2126, 0.7152, 0.07));
	if(albedo == 1.0){
		ALBEDO = texture(scr_tex, SCREEN_UV).rgb;
	}
	else{
		ALBEDO = outline_color;
	}
	
	
	
	
	
	vec3 camera_forward = (INV_VIEW_MATRIX * vec4(0.0, 0.0, -1.0, 0.0)).xyz;
	vec3 world_forward = vec3(0.0, 0.0, 1.0);
	float camera_rot_y = -angle_between_vec2(normalize(camera_forward.xz), normalize(world_forward.xz));
  
	float fovX = radians(FOV) * 2.0;
	float dither_offset_x = VIEWPORT_SIZE.x * camera_rot_y / fovX * cc;
	
	vec3 cam3 = (INV_VIEW_MATRIX*vec4(0.0,0.0,-1.0,0.0)).xyz;
	vec2 cam = vec2(cam3.y, -length(cam3.xz));
	float ang = angle_between_vec2(cam,vec2(0.0,1.0));
	vec2 offset = VIEWPORT_SIZE*ang/vec2(radians(FOV),radians(FOV*(VIEWPORT_SIZE.y/VIEWPORT_SIZE.x)))*2.0;
	vec2 mega_offset = vec2(dither_offset_x,offset.y);
	
	float noise_size = float(textureSize(blue_noise,0).x);
	vec3 blue_n = texture(blue_noise,(SCREEN_UV*(VIEWPORT_SIZE/noise_size)+mega_offset/VIEWPORT_SIZE)/pixelization_size).rgb;
	vec3 src = texture(scr_tex,SCREEN_UV).rgb;
	vec3 outline = ALBEDO;
	mat4 bayer_mat = mat4(vec4(0.0,12.0,3.0,15.0),vec4(8.0,4.0,11.0,7.0),
		vec4(2.0,14.0,1.0,13.0),vec4(10.0,6.0,9.0,5.0))/11.0;
	
	int x = int(SCREEN_UV.x*VIEWPORT_SIZE.x/pixelization_size+mega_offset.x/pixelization_size)%4;
	int y = int(SCREEN_UV.y*VIEWPORT_SIZE.y/pixelization_size+mega_offset.y/pixelization_size)%4;
	
	if (length(outline-outline_color)<=0.05){
		ALBEDO = outline_color;
	}
	else{
		if (src.g <= 0.1){
			float lum = pow(grayScale(vec4(src.rrr,0.0)),(1.0 / 1.3));
			if (lum >= bayer_mat[x][y]+0.053) ALBEDO = bright_color;
			else ALBEDO = dark_color;
		}
		else if (src.g >= 0.01){
			float lum2 = grayScale(vec4(src.rrr,0.0))/1.05;
			if (lum2 >= blue_n.b+0.035) ALBEDO = bright_color;
			else ALBEDO = dark_color;
		}
		else{
			ALBEDO = src;
		}
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
