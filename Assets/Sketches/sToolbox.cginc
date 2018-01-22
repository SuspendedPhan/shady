#ifndef sToolbox
#define sToolbox

float3 f3(float x) { return float3(x, x, x); }
float3 f3(float2 x, float y) { return float3(x.x, x.y, y); }

float2 invlerp(float x, float y, float2 t)
{
	return (t - x) / (y - x);
}

float2 invlerp01(float x, float y, float2 t)
{
	float value = invlerp(x, y, t);
	return saturate(value);
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

fixed4 cursor(float2 st)
{
	float circleRadius = .016;
	float circleWidth = .003;
	float antialias = .003;
	
	fixed4 answer;
	st.x *= _ScreenParams.x / _ScreenParams.y;
	float2 mouse = uMouse;
	mouse.x *= _ScreenParams.x / _ScreenParams.y;
	float dist = distance(st, mouse);
	float lum = invlerp01(circleRadius, 0, dist);
	answer.rgb = 1;
	answer.a = .75 * step(dist, circleRadius);
	answer.rgb = answer.rgb * step(dist, circleRadius);
	answer.a +=
		smoothstep(circleRadius, circleRadius + antialias, dist) *
		smoothstep(
			circleRadius + circleWidth + antialias,
			circleRadius + circleWidth,
			dist);
	// TODO: visualize mouse.x, mouse.y
	return answer;
}

float noise(float x)
{
	float i = floor(x);
	// return random(i);
	return lerp(random(i), random(i + 1), frac(x));
}

#endif