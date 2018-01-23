fixed4 s02Noise(float2 uv)
{
    float seed = 79 * uMouse.x;
    float distortion = .5;
    float cols = 10;

    float4 cc = 0;
    float x = uv.x;
    x *= cols;
    float ix = floor(x);

    float lo = ix == 0 ? 0 :
        ix - 1 + random(seed + ix - 1) * distortion;
    float mi =
        ix + random(seed + ix) * distortion;
    float hi = ix == cols - 1 ? cols :
        ix + 1 + random(seed + ix + 1) * distortion;

    cc += invlerp01(lo, mi, x) * step(x, mi);
    cc += invlerp01(mi, hi, x) * step(mi, x);

    return cc;
}