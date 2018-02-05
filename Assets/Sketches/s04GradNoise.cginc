fixed4 s04GradNoise(float2 uv)
{
    float4 cc = 0;
    float2 st = uv;
    st = st * 2 - 1;

    float scale = 100 * uMouse.y;
    float offset = 100 * uMouse.x;

    scale = 5;
    offset = 0;

    float qq = gnoise211(st * scale + offset);
    float r = length(st);
    // cc = step(r, qq);
    // cc = step(qq, );

    float fo = 5 * uMouse.x;
    float gain = max(1, 10 * uMouse.y);
    fo=0;
    gain=1;

    qq = qq*.5+.5;
    qq += fo;
    cc = pow(qq, gain);
    return cc;
}