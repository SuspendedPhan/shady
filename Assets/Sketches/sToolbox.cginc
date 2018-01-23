#ifndef sToolbox
#define sToolbox

float3 f3(float x) { return float3(x, x, x); }
float3 f3(float2 x, float y) { return float3(x.x, x.y, y); }

float2 invlerp(float x, float y, float2 t)
{
	return (t - x) / (y - x);
}

float invlerp(float x, float y, float t)
{
	return (t - x) / (y - x);
}

float2 invlerp01(float x, float y, float2 t)
{
	float value = invlerp(x, y, t);
	return saturate(value);
}
float invlerp01(float x, float y, float t)
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

float random11(float x)
{
	return random(x) * 2 - 1;
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

float tri(float x)
{
	return abs(frac(x)*2-1);
}

float bounce01(float x)
{
	return 1 - abs(saturate(x)*2-1);
}

float smoothbounce01(float x)
{
	x = saturate(x);
	return
		smoothstep(0, .5, x) * step(x, .5) +
		smoothstep(1, .5, x) * step(.5, x);
}

void distortGrid(float x01, float cells, out float iPos, out float fPos)
{
	float seed = 79;
    float distortion = .5;

    float4 cc = 0;
    float x = x01 * (cells - 1);
    float ix = floor(x);

    float lo = ix == 0 ? 0 :
        ix - 1 + random(seed + ix - 1) * distortion;
    float mi =
        ix + random(seed + ix) * distortion;
    float hi = ix == cells - 2 ? cells - 1 :
        ix + 1 + random(seed + ix + 1) * distortion;

    fPos = 0;
    fPos += invlerp01(lo, mi, x) * step(x, mi);
    fPos += invlerp01(mi, hi, x) * step(mi, x);
    iPos = ix;
    if (x > mi) iPos += 1;
}

#endif