fixed4 s02Noise(float2 uv)
{
	float tt = frac(uv.x * 10);
	tt = step(tt, .01);
	return noise(uv.x * 10 + 100000) + tt;
	return .5;
}