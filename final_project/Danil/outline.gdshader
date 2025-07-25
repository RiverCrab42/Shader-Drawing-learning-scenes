//
//shader_type spatial;
//uniform sampler2D scr_tex: hint_screen_texture;
//uniform sampler2D normal_tex: hint_normal_roughness_texture;
//uniform sampler2D depth_tex: hint_depth_texture;
//
//uniform float tresh_hold_n : hint_range(0.0, 1.0, 0.01);
//uniform float tresh_hold_d : hint_range(0.0, 1.0, 0.01);
//
//uniform sampler2D hatch_down_left;
//uniform sampler2D hatch_down_right;
//render_mode unshaded;
//
//vec3 texel_fetch(sampler2D tex, vec2 size, vec2 coord){
	//float x = fract(coord.x/size.x) * size.x;
	//float y = fract(coord.y/size.y) * size.y;
	//return texelFetch(tex, ivec2(int(x), int(y)), 0).rgb;
//}
//
//vec3 linear_depth(mat4 M, vec2 SUV, vec2 shift){
	//vec4 v = M * vec4((vec2(SUV.x, SUV.y) + vec2(shift.x, shift.y))*2.0-1.0, texture(depth_tex, SUV + shift).r, 1.0);
	//return v.xyz/v.w;
//}
//
//vec2 wave(float y, float x, mat4 IPM){
	//vec3 depth = linear_depth(IPM, vec2(x, y), vec2(0.0,0.0));
	//return vec2(x + cos(depth.y*11.0)/700.0, y);
//}
//
//void vertex() {
	//POSITION = vec4(VERTEX.x, VERTEX.y, 1.0, 1.0);
//}
//
//void fragment() {
	//vec2 tex_size = vec2(float(textureSize(hatch_down_left, 0).x), float(textureSize(hatch_down_left, 0).y));
	//float px_size_x = 1.0/VIEWPORT_SIZE.x;
	//float px_size_y = 1.0/VIEWPORT_SIZE.y;
//
	//mat3 Gx = mat3(vec3(-1, -2, -1), vec3(0, 0, 0), vec3(1, 2, 1));
	//mat3 Gy = mat3(vec3(-1, 0, 1), vec3(-2, 0, 2), vec3(-1, 0, 1));
	//float Gxx = 0.0;
	//float Gyy = 0.0;
//
	//for(int i=0; i<3; i++){
		//vec3 a = linear_depth(INV_PROJECTION_MATRIX, wave(SCREEN_UV.y+float(i-1)*px_size_y, SCREEN_UV.x-px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX), vec2(0.0));
		//vec3 b = linear_depth(INV_PROJECTION_MATRIX, wave(SCREEN_UV.y+float(i-1)*px_size_y, SCREEN_UV.x+px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX), vec2(0.0));
		//vec3 normal = texture(normal_tex, wave(float(i-1)*px_size_y + SCREEN_UV.y, SCREEN_UV.x + px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).xyz *2.0 -1.0;
		//if(a.z < -1000.0){
				//Gxx +=0.0;
				//
			//}
		//else
		//Gxx += dot(a-b, normal) * Gx[0][i];
		//
	//}
	//for(int i=0; i<3; i++){
		//vec3 a = linear_depth(INV_PROJECTION_MATRIX, wave(SCREEN_UV.y-px_size_y, SCREEN_UV.x+float(i-1)*px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX), vec2(0.0));
		//vec3 b = linear_depth(INV_PROJECTION_MATRIX, wave(SCREEN_UV.y+px_size_y, SCREEN_UV.x+float(i-1)*px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX), vec2(0.0));
		//vec3 normal = texture(normal_tex, wave(px_size_y +SCREEN_UV.y, SCREEN_UV.x + float(i-1)*px_size_x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).xyz * 2.0 - 1.0;
		//if(a.z < -1000.0){
			//Gyy +=0.0;
		//}
		//else
			//Gyy += dot(a-b, normal) * Gy[i][0];
	//}
	//float grey_d = step(tresh_hold_d, sqrt(pow(Gxx, 2)+ pow(Gyy, 2)));
	//vec2 uv = SCREEN_UV + vec2(-px_size_x, -px_size_y);
	//vec3 v1 = texture(normal_tex, wave(uv.y, uv.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb;
	//Gxx = 0.0;
	//Gyy=0.0;
	//for(float j=-1.0; j<=1.0; j++){
		//for(float i=-1.0; i<=1.0; i++){
			//vec2 shift_pixels = vec2(px_size_x * i, px_size_y*j);
			//uv = SCREEN_UV + shift_pixels;
			//vec3 normal = texture(normal_tex, wave(uv.y, uv.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).xyz;
			//
			//float gray_scale_n = distance(normal, v1);
			//
			//float gray_scale =  gray_scale_n;
			//Gxx += gray_scale * Gx[int(j)+1][int(i)+1];
			//Gyy += gray_scale * Gy[int(j)+1][int(i)+1];
			//
			//v1 = texture(normal_tex, wave(uv.y, uv.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb;
		//}
	//}
	////ALBEDO = vec3(clamp(grey_d +step(tresh_hold_n, sqrt(pow(Gxx, 2) + pow(Gyy, 2))*1.0), 0.0, 1.0));
	//float albedo = 1.0 - clamp(grey_d +step(tresh_hold_n, sqrt(pow(Gxx, 2) + pow(Gyy, 2))*1.0), 0.0, 1.0);
	//float color_grey = dot(texture(scr_tex, SCREEN_UV).rgb, vec3(0.2126, 0.7152, 0.07));
	//if(albedo == 1.0){
		//ALBEDO = texture(scr_tex, wave(SCREEN_UV.y, SCREEN_UV.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb;
	//}
	//else{
		//ALBEDO = vec3(albedo);
	//}
	//if(color_grey < 0.05){
		//ALBEDO = texel_fetch(hatch_down_left, tex_size, wave(FRAGCOORD.y, FRAGCOORD.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb 
				 //* texture(scr_tex, vec2(SCREEN_UV.x+cos(SCREEN_UV.y*11.0)/700.0, SCREEN_UV.y)).rgb;
		//if(color_grey < 0.02){
			//ALBEDO = texel_fetch(hatch_down_left, tex_size, wave(FRAGCOORD.y, FRAGCOORD.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb 
					 //* texel_fetch(hatch_down_right, tex_size, wave(FRAGCOORD.y, FRAGCOORD.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb 
					 //* texture(scr_tex, wave(SCREEN_UV.y, SCREEN_UV.x, INV_VIEW_MATRIX * INV_PROJECTION_MATRIX)).rgb;
		//}
	//}
//}	

shader_type spatial;
uniform sampler2D scr_tex: hint_screen_texture;
uniform sampler2D normal_tex: hint_normal_roughness_texture;
uniform sampler2D depth_tex: hint_depth_texture;

uniform float tresh_hold_n : hint_range(0.0, 1.0, 0.01);
uniform float tresh_hold_d : hint_range(0.0, 1.0, 0.01);
uniform float coff : hint_range(0.0, 1.5
, 0.01);

uniform sampler2D hatch_down_left;
uniform sampler2D hatch_down_right;
render_mode unshaded;

vec3 texel_fetch(sampler2D tex, vec2 size, vec2 coord){
	float x = fract(coord.x/size.x) * size.x;
	float y = fract(coord.y/size.y) * size.y;
	return texelFetch(tex, ivec2(int(x), int(y)), 0).rgb;
}

vec3 linear_depth(mat4 M, vec2 SUV, vec2 shift){
	vec4 v = M * vec4((vec2(SUV.x, SUV.y) + vec2(shift.x, shift.y))*2.0-1.0, texture(depth_tex, SUV + shift).r, 1.0);
	return v.xyz/v.w;
}

void vertex() {
	POSITION = vec4(VERTEX.x, VERTEX.y, 1.0, 1.0);
}

void fragment() {
	vec2 tex_size = vec2(float(textureSize(hatch_down_left, 0).x), float(textureSize(hatch_down_left, 0).y));
	float px_size_x = 1.0/VIEWPORT_SIZE.x;
	float px_size_y = 1.0/VIEWPORT_SIZE.y;

	mat3 Gx = mat3(vec3(-1, -2, -1), vec3(0, 0, 0), vec3(1, 2, 1));
	mat3 Gy = mat3(vec3(-1, 0, 1), vec3(-2, 0, 2), vec3(-1, 0, 1));
	
	float Gxx = 0.0;
	float Gyy = 0.0;
	
	for(int i=0; i<3; i++){
		vec3 a = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(-px_size_x,  float(i-1)*px_size_y)*coff);
		vec3 b = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(px_size_x, float(i-1)*px_size_y)*coff);
		vec3 normal = texture(normal_tex, vec2(SCREEN_UV.x + px_size_x, SCREEN_UV.y + float(i-1)*px_size_y)).xyz *2.0 -1.0;
		if(a.z < -1000.0){
				Gxx +=0.0;
				
			}
		else
		Gxx += dot(a-b, normal) * Gx[0][i];
		
	}
	
	for(int i=0; i<3; i++){
		vec3 a = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(float(i-1)*px_size_x, - px_size_y)*coff);
		vec3 b = linear_depth(INV_PROJECTION_MATRIX, SCREEN_UV, vec2(float(i-1)*px_size_x, px_size_y)*coff);
		vec3 normal = texture(normal_tex, vec2(SCREEN_UV.x + float(i-1)*px_size_x, SCREEN_UV.y + px_size_y)).xyz * 2.0 - 1.0;
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
			vec2 shift_pixels = vec2(px_size_x * i, px_size_y*j)*coff;
			vec3 normal = texture(normal_tex, SCREEN_UV + shift_pixels).xyz;
			
			float gray_scale_n = distance(normal, v1);
			
			float gray_scale =  gray_scale_n;
			Gxx += gray_scale * Gx[int(j)+1][int(i)+1];
			Gyy += gray_scale * Gy[int(j)+1][int(i)+1];
			
			v1 = texture(normal_tex, SCREEN_UV + shift_pixels).rgb;
		}
	}
	
	ALBEDO = vec3(clamp(grey_d +step(tresh_hold_n, sqrt(pow(Gxx, 2) + pow(Gyy, 2))*1.0), 0.0, 1.0));
}	
