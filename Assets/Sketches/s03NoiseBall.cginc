fixed4 s03NoiseBall(float2 uv)
{
    float4 cc = 0;
    float2 st = uv;
    // st *= 5;
    // st = frac(st);
    // st*=10;
    // float2 sti = floor(st);
    // if (mod(4,7,sti.x) == 5)
    // {
    //     cc = 1;
    // }
    // else
    // {
    //     cc = frac(st.x);
    // }
    // return cc;

    st = uv * 2 - 1;
    float2 stnoise = st;
    stnoise *= 1000 * (uMouse.x * uMouse.x);
    stnoise.y += uMouse.y * uMouse.y * 1000;

    float r = length(st);
    float a = atan01(st);
    stnoise = float2(r, a);
    // stnoise *= 1000 * (uMouse.x * uMouse.x);
    // stnoise.y += uMouse.y * uMouse.y * 1000;
    // float2 n = modnoise(stnoise);
    float2 n = noise2(stnoise);

    float scale = 5;
    float offset = 0;
    scale = floor(1000 * uMouse.y * uMouse.y);
    // offset = .0001 * uMouse.x * uMouse.x;
    scale = tri(_Time.x)*200;

    n = noise2(float2(a, r)*scale+offset);
    // n = modnoise2(float2(a, r), scale, offset);
    // n = modnoise2(float2(a, r), scale, offset);
    // n.y = noise(r*100);
    // float2 n = float2(noise(stnoise.x), noise(stnoise.y));
    // n = noise2(r, a);
    // n += 1 * r;

    cc += step(abs(a - n.x), .1);
    cc += step(abs(1 - a - n.x), .1);
    cc *= featherstep(abs(r - n.y), .1, .1);

    // cc = modnoise(frac(st.x + offset), floor(scale), 0);
    // cc = step(r, n.y);
    // cc *= step(st.y, n.y);
    // cc = step(a, n.y);
    return cc;
}