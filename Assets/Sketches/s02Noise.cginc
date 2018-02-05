fixed4 s02Noise(float2 uv)
{
    float feather = .005;

    float4 cc = 0;
    float t = _Time.z;
    // t=0;
    float2 st = uv;
    float aspect = _ScreenParams.y / _ScreenParams.x;
    st = st * 2 - 1;
    st.y *= aspect;
    float r = length(st);
    float qq = noise(t);
    cc = 1;
    cc += smoothstep(qq, qq - feather, r);

    qq = noise(t + .455);
    cc.rg -= smoothstep(qq, qq - feather, r) * float2(.3, .6);

    qq = noise(t + 65.455);
    qq = sin(qq) / 2 + 1;
    float feather2 = noise(t + 65.455) * .1;
    cc.rg -= smoothstep(qq, qq - feather2, r) * float2(.3, .6);    

    qq = noise(t * 1.2 + 65.455);
    qq = sin(qq) / 2 + 1;
    float feather3 = noise(t * .8 + 65.455) * .15;
    cc.rg -= smoothstep(qq, qq - feather, r) * float2(.3, .1);

    return cc;
    // float iPos;
    // float fPos;
    // distortGrid(uv.x, 4, iPos, fPos);
    // float2 st = float2(fPos, uv.y);

    // if (iPos % 3 == 0) return .5;
    // return fPos;
}