shader_type spatial;
uniform float[2] woterspeed;
uniform float[2] xk;
uniform float[2] jxk;
uniform float[2] lkm;

void vertex() {
	//f
	VERTEX.y = cos(VERTEX.x*lkm[0] + VERTEX.z * xk[0] + TIME * woterspeed[0]) * jxk[0];
	VERTEX.y += sin(VERTEX.x*lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]) * jxk[1];
	float volna10 = lkm[0] * jxk[0] * sin( VERTEX.x * lkm[0] + VERTEX.z + xk[0] + TIME * woterspeed[0]);
	float volna11 = lkm[1] * jxk[1] * cos(VERTEX.x * lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]);
	float volna20 = xk[0] * jxk[0] * sin(VERTEX.x * lkm[0] + VERTEX.z * xk[0] + TIME * woterspeed[0]);
	float volna21 = xk[1] * jxk[1] * cos(VERTEX.x * lkm[1] + VERTEX.z * xk[1] + TIME * woterspeed[1]);
	//VERTEX.y = cos(VERTEX.x * woterspeed + TIME * xk) + cos(VERTEX.z * woterspeed + TIME * xk);
	NORMAL = normalize(vec3(volna10 - volna11, 1.0 , volna20 - volna21));
	//jxk * xk * sin(woterspeed * TIME + xk * VERTEX.z + VERTEX.x)
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.01,0.0,0.4);
	// Called for every pixel the material is visible on.
}
//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
