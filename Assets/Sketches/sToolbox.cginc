#ifndef sToolbox
#define sToolbox

float2 f2(float x) { return float2(x, x); }
float3 f3(float x) { return float3(x, x, x); }
float3 f3(float2 x, float y) { return float3(x.x, x.y, y); }

float sin01(float x)
{
	return sin(x) / 2 + .5;
}

float mod(float lo, float hi, float x)
{
	float div = hi - lo;
	return lo + lo % div + x % div;
}

float2 mod(float2 lo, float2 hi, float2 x)
{
	float2 div = hi - lo;
	return lo + lo % div + x % div;
}

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

float smoothlerp(float x, float y, float t)
{
	return lerp(x, y, smoothstep(0, 1, t));
}

float2 rotate(float2 st, float angle)
{
    st -= 0.5;
    st = mul(float2x2(cos(angle),-sin(angle),
		sin(angle),cos(angle)), st);
    st += 0.5;
    return st;
}

// float random(float2 _st) {
//     return frac(sin(dot(_st.xy,
//                          float2(12.9898,78.233)))*
//         43758.5453123);
// }

float random(float2 co)
{
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy,float2(a,b));
    float sn = dt % 3.14;
    return frac(sin(sn) * c);
}

float random11(float x)
{
	return random(x) * 2 - 1;
}

float2 random211(float2 st)
{
	return float2(random(st), random(st * .572 + 35.67)) * 2 - 1;
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
	return lerp(random(i), random(i + 1), smoothstep(0, 1, frac(x)));
}

float noise2(float2 st)
{
	float seed = 0;
	float2 ones = float2(0, 1);
	float2 sti = floor(st);
	float2 stf = frac(st);
	float tl = random(seed + sti + ones.xy);
	float tr = random(seed + sti + ones.yy);
	float bl = random(seed + sti + ones.xx);
	float br = random(seed + sti + ones.yx);

	float top = smoothlerp(tl, tr, stf.x);
	float bot = smoothlerp(bl, br, stf.x);
	return smoothlerp(bot, top, stf.y);
}

float noise2(float x, float y)
{
	return noise2(float2(x, y));
}

float noise211(float2 x)
{
	return noise2(x) * 2 - 1;
}

float modnoise(float x01, float scalei, float seed)
{
	return 0;  // i don't think this is working
	float x = x01;
	x *= scalei;
	float starti = floor(x);
	float endi = floor(mod(seed, seed + scalei, (x + 1)));
	endi = floor((x + 1) % scalei);
	return smoothlerp(random(starti + seed), random(endi + seed), frac(x));
}

float modnoise2(float2 st01, float scalei, float seed=0)
{
	return 0;  // i don't think this is working
	float2 st = st01 * scalei;
	float2 ones = float2(0, 1);
	float2 sti = floor(st);
	float2 stf = frac(st);

	float tl = random(seed + mod(seed, seed + scalei, sti + ones.xy));
	float tr = random(seed + mod(seed, seed + scalei, sti + ones.yy));
	float bl = random(seed + mod(seed, seed + scalei, sti + ones.xx));
	float br = random(seed + mod(seed, seed + scalei, sti + ones.yx));
	float top = smoothlerp(tl, tr, stf.x);
	float bot = smoothlerp(bl, br, stf.x);
	return smoothlerp(bot, top, stf.y);
}

float gnoise211(float2 st)
{
	float seed = 0;
	float2 ones = float2(0, 1);
	float2 sti = floor(st);
	float2 stf = frac(st);
	float tl = dot(random211(seed + sti + ones.xy), ones.xy - stf);
	float tr = dot(random211(seed + sti + ones.yy), ones.yy - stf);
	float bl = dot(random211(seed + sti + ones.xx), ones.xx - stf);
	float br = dot(random211(seed + sti + ones.yx), ones.yx - stf);

	// return tr;
	float top = smoothlerp(tl, tr, stf.x);
	float bot = smoothlerp(bl, br, stf.x);
	return smoothlerp(bot, top, stf.y);
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

float atan01(float2 st)
{
	return frac(invlerp(-PI, PI, atan2(st.y, st.x)) + .5);
}

float featherstep(float lo, float hi, float feather)
{
	return smoothstep(lo - feather, lo, hi);
}

float featherstep(float lo, float hi)
{
	return featherstep(lo, hi, .01);
}

#endif