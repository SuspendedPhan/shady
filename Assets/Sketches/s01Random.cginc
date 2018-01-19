float uOffset;

fixed4 s01Random(float2 uv)
{
	uv *= 200;
	float2 ipos = floor(uv);
	float2 fpos;
	float vel = random(ipos.y)*100;
	float offst = vel * uTime + (uOffset * vel);
	uv.x -= offst;
	
	ipos = floor(uv);
	fpos = frac(uv);
	return step(random(ipos), lerp(.99, .5, uMouse.x));
}