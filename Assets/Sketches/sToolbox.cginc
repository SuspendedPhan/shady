#ifndef sToolbox
#define sToolbox

float3 f3(float x) { return float3(x, x, x); }
float3 f3(float2 x, float y) { return float3(x.x, x.y, y); }

float2 invlerp(float x, float y, float2 t)
{
	return (t - x) / (y - x);
}
float2 rotate(float2 st, float angle)
{
    st -= 0.5;
    st = mul(float2x2(cos(angle),-sin(angle),
		sin(angle),cos(angle)), st);
    st += 0.5;
    return st;
}

float random(float2 _st) {
    return frac(sin(dot(_st.xy,
                         float2(12.9898,78.233)))*
        43758.5453123);
}

float random(float x) {
	return random(float2(0, x));
}

float randGauss(float2 x) {
	float value =
		random(x) +
		random(x + 5325.123) +
		random(x + 2325.143) +
		random(x + 2328.423);
 	return value / 4;
}

#endif