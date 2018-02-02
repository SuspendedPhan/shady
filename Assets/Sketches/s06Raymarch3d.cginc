float sdf(float3 p, out float color)
{
    float radius = 1;
    float3 light = float3(-1, -1, 1);
    float3 center = float3(lerp(-5, 5, uMouse.x), .5, lerp(0, 100, uMouse.y));
    float3 toP = p - center;
    float3 n = normalize(toP);
    color = dot(-light, n);
    float d = length(toP) - radius;
    color *= smoothstep(0, -.01, d);
    return d;
}

fixed4 s06Raymarch3d(float2 uv)
{
    float2 st = uv;
    float fov01 = .166666667;
    float3 ro = float3(st.x, st.y, 0);
    float3 rd;

    float3 xmin = float3(-fov01, 0, 1 - fov01);
    float3 xmax = float3(fov01, 0, 1 - fov01);
    float3 ymin = float3(0, -fov01, 1 - fov01);
    float3 ymax = float3(0, fov01, 1 - fov01);

    float3 center = float3(0, 0, 10);
    xmax /= xmax.z;
    xmin /= xmin.z;
    ymax /= ymax.z;
    ymin /= ymin.z;
    float3 right = xmax - center;
    float3 left = xmin - center;
    float3 up = ymax - center;
    float3 down = ymin - center;

    float3 tr = xmax + up;
    float3 tl = xmin + up;
    float3 br = xmin + down;
    float3 bl = xmax + down;

    rd.x = lerp(xmin.x, xmax.x, ro.x);
    rd.y = lerp(ymin.y, ymax.y, ro.y);
    rd.z = 1;
    rd = normalize(rd);

    float3 p = ro;
    float maxdist = 10;
    float steps = 64;
    float raydist = 0;
    float4 answer;
    float compute = 0;
    for (float i = 0; i < steps; i++)
    {
        compute = i / steps;
        float color;
        float d = sdf(p, color);
        raydist += max(d, .01);
        if (raydist > 500) break;
        if (d < 0)
        {
            answer.rgb = color;
        }
        p += rd * max(d, .01);
    }
    return answer;
    float3 computeColor = lerp(float3(0, 0, 1), float3(1, 0, 0), compute);
    answer.rgb = lerp(answer.rgb, computeColor, .5);
    answer.a = 1;
    return answer;
}