shader_type canvas_item;

uniform sampler2D scrTex : hint_screen_texture,repeat_enable;
uniform float DisCenter;
// Условная степень приближения к центру от краев (0 - начало, 1 - конец, >1 - соединение)
uniform float PowerSin = 100.0;
// Сила искажения изображения в тумане
uniform sampler2D FogTexture;
// Текстура тумана
uniform sampler2D FogBoard;
// Текстура границы тумана


void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pos = 2.0*SCREEN_UV - 1.0;
	// pos  - вектор от центра до точки вызова
	vec4 colorTex = texture(scrTex,SCREEN_UV);
	// colorTex - цвет с текстуры экрана
	vec4 FogColor = texture(FogTexture,SCREEN_UV);
	// FogColor - цвет шума для тумана
	vec4 FogBoardColor = texture(FogBoard,SCREEN_UV);
	// FogBoardColor - цвет для границы тумана
	float Corruption = sin((TIME/4.0+SCREEN_UV.y)*10.0)/300.0;
	// Степень искажения горизонтально, меняется со временем
	
	// Левая часть тумана
	if (DisCenter > 1.0 + pos.x){  // Если степень сближения больше расстояния от точки до центра со смещением на 1 (pos.x [0.0,1.0]
		
		COLOR = texture(scrTex, vec2(SCREEN_UV.x + Corruption,SCREEN_UV.y)); // Тогда цвет = изображению экрана со сдвигом по горизонтали
																								  // на синус от времени и вертикальной позиции
		
		//if ( Corruption < SCREEN_UV.x){ // Если степени схождения пополам с искажением из прошлого условия больше исходной позиции
		//	COLOR = colorTex;								  // то эффект искажения отменяется
		//}
		//else{												  // Иначе цвет экрана с эффектом искажения смешивается с цветом тумана
		//	COLOR = mix(FogColor,COLOR,abs(0.3));
		//}
		//if (abs(DisCenter/2.0 - 0.02 + Corruption/100.0 - SCREEN_UV.x) < 0.005){
		//	COLOR = FogBoardColor; 	// Если модуль разности степени схождения пополам с искажением и позиции на эккране меньше ширины границы, то цвет заменяется на цвет границы тумана
			
		//}
		//COLOR = vec4(mix(colorTex.rgb,vec3(1.0),sin(3.0)),1.0);
	}
	
	// Правая часть тумана
	if (DisCenter > 1.0 - pos.x){
		COLOR = texture(scrTex, vec2(SCREEN_UV.x*1.0 + sin(SCREEN_UV.y*30.0 + TIME*5.0)/PowerSin,SCREEN_UV.y));
		
		if (1.0 - DisCenter/2.0 + 0.02 - sin((SCREEN_UV.y - TIME/30.0)*30.0 + TIME*5.0)/100.0 > SCREEN_UV.x){
			COLOR = colorTex;
		}
		else{
			COLOR = mix(FogColor,COLOR,abs(0.3));
		}
		if (abs(1.0 - DisCenter/2.0 + 0.02 - sin((SCREEN_UV.y - TIME/30.0)*30.0 + TIME*5.0)/100.0 - SCREEN_UV.x) < 0.005){
			COLOR = FogBoardColor;
			
		}
	}
	
	
	
	//COLOR = colorTex;
	
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
