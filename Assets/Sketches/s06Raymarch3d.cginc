float sdPlane(float4 n, float3 p)
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float sdBox( float3 p, float3 b )
{
  float3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sdf(float3 p, out float color)
{
    color = 0;
    float color1;
    float d1;
    {
        float radius = 1;
        float3 light = float3(-1, -1, 1);
        float3 center = float3(
            0, 0, 12);
            // lerp(-5, 5, uMouse.x), lerp(-5,5,uMouse.y), 12);
        float3 toP = p - center;
        float3 n = normalize(toP);
        float d = length(toP) - radius;
        if (d <= 0)
        {
            color = dot(-light, n);
        }
        color1 = dot(-light, n);
        // color *= smoothstep(0, -.01, d);
        d1 = d;
        // return d;
    }

    float d2;
    {
        // float radius = 1;
        // float3 light = float3(-1, -1, 1);
        // float3 center = float3(
        //     0, 2, 10);
        // float3 toP = p - center;
        // float3 n = normalize(toP);
        // float color2 = 0;
        // color2 += dot(-light, n);
        // float d = length(toP) - radius;
        // // color2 *= smoothstep(0, -.01, d);
        // color += color2;
        // d2 = d;
    }

    float color2 = .5;
    {
        // float planeD = sdPlane(float4(0,1,0,10), p);
        // if (planeD <= 0) color += .5;
        // d2 = planeD;
    }

    {
        float d = sdBox(p - float3(1, .5, 15*uMouse.x), float3(1, 1, 2));
        d2 = d;
    }

    if (d1 < d2)
    {
        color = color1;
    }
    else
    {
        color = color2;
    }
    return min(d1, d2);
    // float planeD = sdPlane(float4(0,1,0,0), p);
    // if (planeD < 0) color += .5;
    // return min(d, planeD);
}

fixed4 s06Raymarch3d(float2 uv)
{
    // This is a box that doesn't work.

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
    float maxdist = 100000;
    float stepsize = .2;
    float steps = 100;
    float raydist = 0;
    float4 answer;
    float compute = 0;
    for (float i = 0; i < steps; i++)
    {
        compute = i / steps;
        float color;
        float d = sdf(p, color);
        raydist += max(d, stepsize);
        if (raydist > maxdist) break;
        if (d <= 0)
        {
            answer.rgb = color;
        }
        p = rd * raydist;
    }
    return answer;
    float3 computeColor = lerp(float3(0, 0, 1), float3(1, 0, 0), compute);
    answer.rgb = lerp(answer.rgb, computeColor, .5);
    answer.a = 1;
    return answer;
}