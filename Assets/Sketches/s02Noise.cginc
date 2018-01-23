fixed4 s02Noise(float2 uv)
{
    float iPos;
    float fPos;
    distortGrid(uv.x, 4, iPos, fPos);
    // if (iPos % 3 == 0) return .5;
    return fPos;
}