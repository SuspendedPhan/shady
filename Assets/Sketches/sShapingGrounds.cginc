#ifndef sShapingGrounds
#define sShapingGrounds

float shapingGrounds_func(float x)
{
    return smoothbounce01(x);
}

fixed4 shapingGrounds(v2f i)
{
    float lineWidth = .05;
    float ballRadius = .05;
    float feather = .01;
    float y = shapingGrounds_func(i.uv.x);  // shape func

    float2 st = i.uv;
    float t = frac(_Time.y/2);

    fixed4 ww =
        smoothstep(y - lineWidth, y, st.y) * step(st.y, y) +
        smoothstep(y + lineWidth, y, st.y) * step(y, st.y);

    float q = invlerp(y - lineWidth, y + lineWidth, st.y);
    q = smoothbounce01(q);
    ww = q;
    ww = saturate(ww);

    {
        float yt = shapingGrounds_func(t);
        float r = distance(st, float2(1 - ballRadius, yt));
        float tt = step(r, ballRadius) * smoothstep(ballRadius, ballRadius - feather, r);
        ww += tt;
    }

    {
        float2 st11 = st * 2 - 1;
        float r = length(st11);
        float radius = shapingGrounds_func(t) * ballRadius * 3;
        float tt = step(r, radius) * smoothstep(radius, radius - feather, r);
        ww += tt;
    }

    return ww;
}

#endif