float sdf(float2 p, out float color)
{
    float2 st = p - uMouse;
    color = 1;
    // return max(distance(p, float2(.5, .5)) - .2,
    //     distance(p, float2(.6, .5)) - .2);

    // float a = atan01(st);
    // a += frac(_Time.z);
    // float r = length(st);
    // float d = a % .25 - .1;
    // color = 1;
    // return max(d, r - .1);

    float2 light = float2(1, 1);

    float d1 = distance(p, uMouse) - .1;
    float d2 = distance(p, float2(.4, .5)) - .1;
    float d3 = distance(p, float2(.5, .8)) - .1;

    float mind = min(d1, d2, d3);
    if (mind > 0)
    {
        color = 0;
    }
    else if (mind == d1)
    {
        float2 n = normalize(p - uMouse);
        float2 toLight = normalize(light - (p + n * .1));
        color = dot(n, toLight);
        // color = saturate(dot(normalize(p - uMouse), float2(1 - sin(_Time.y), sin(_Time.z))));
        // color = .25;
    }
    else if (mind == d2)
    {
        color = .5;
    }
    else if (mind == d3)
    {
        color = .75;
    }
    return mind;
}

fixed4 s05Raymarch(float2 uv)
{
    if (uv.y > .02)
    {
        float unused;
        return sdf(uv, unused) < 0 ? unused : 0;
    }
    float st = uv;
    // st.x *= 10;
    // st.x = floor(st.x);
    // st.x /= 10;
    float fov01 = .75;
    float2 ro = float2(st.x, 0);
    float2 rd;
    rd.x = lerp(-fov01, fov01, ro.x);
    rd.y = 1 - abs(rd.x);

    // if (dot(uv - ro, rd) < 0) return .1;
    // return 1;

    float2 p = ro;
    for (float i = 0; i < 20; i++)
    {
        p += rd * 1. / 20.;
        float color;
        if (sdf(p, color) < 0) return color;
    }
    return 0;
}