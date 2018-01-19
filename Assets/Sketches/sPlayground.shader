Shader "Playground"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		rcSize ("rcSize", Vector) = (10,5,0,0)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float uTime;
			float2 uMouse;
			float2 rcSize;
			static const float PI = 3.14159265f;
			static const float TWOPI = PI * 2;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			#include "sToolbox.cginc"
			#include "s01Random.cginc"
			#include "sShapingGrounds.cginc"

			fixed4 test(v2f i)
			{
				float2 st = i.uv.xy;
				float lum = 0;
				float totalScale = 3;

				st *= 3;
				float2 rc = floor(st);
				st = frac(st);
				st = st * 2 - 1;

				// float ii = -0;
				// float jj = -1;
				// float2 ij = float2(ii, jj);
    //             float2 n = float2(-jj, ii);
    //             float2 bound1 = .5 * -n + .5 * -ij;
    //             float2 bound2 = ij + n * .5;
    //             float2 min_bound = min(bound1, bound2);
    //             float2 max_bound = max(bound1, bound2);

                // lum +=
                //     step(min_bound.x, st.x) *
                //     step(st.x, max_bound.x) *
                //     step(min_bound.y, st.y) *
                //     step(st.y, max_bound.y);
                lum += 1 - length(st);

		        for (int ii = -1; ii <= 1; ii++)
		        {
		            if (rc.x + ii < 0) continue;
		            if (rc.x + ii >= totalScale) continue;
		            for (int jj = -1; jj <= 1; jj++)
		            {
		                if (abs(ii) == abs(jj)) continue;
		                if (rc.y + jj < 0) continue;
		                if (rc.y + jj >= totalScale) continue;
		                if (random(rc) + random(rc + float2(ii, jj)) < 1) continue;
						float2 ij = float2(ii, jj);
		                float2 n = float2(-jj, ii);
		                float2 bound1 = .5 * -n + .5 * -ij;
		                float2 bound2 = ij + n * .5;
		                float2 min_bound = min(bound1, bound2);
		                float2 max_bound = max(bound1, bound2);

		                lum +=
		                    step(min_bound.x, st.x) *
		                    step(st.x, max_bound.x) *
		                    step(min_bound.y, st.y) *
		                    step(st.y, max_bound.y);
		            }
		        }
				// lum = 1;
		        fixed4 answer;
		        answer.a = 0;
		        answer.rgb = lum;
		        return answer;
		    }

		    fixed4 test2 (v2f i) {
		    	fixed4 answer;
		    	float lum = 0;
		    	float2 st = i.uv;
		    	float v = 0;
		    	st-=.5;
		    	float theta = atan2(st.y, st.x);
		    	theta += 3.14;
		    	theta %=.2;
		    	float r = length(st);
		    	st.x = r*cos(theta);
		    	st.y=r*sin(theta);
		    	st = st%.1;
		    	answer.xy = st;
		    	lum = step(st.y/st.x,.1);
		    	lum=pow(lum,20);
		    	return lum;
		    	return answer;
		    	// st*=3;
		    	// st.x %= 1;
		    	// lum = step((st.y/st.x+.2*1000)%.2, .03);
		    	// float tr = st.x;
		    	// st.x += .3;
		    	// st.x = st.y;
		    	// st.y = tr;
		    	// lum+=step((st.y/st.x+.2*1000)%.2, .03);
		    	// lum = lum * step(st.y%.2,.1);
		    	// lum = abs((st.y/st.x)%.5);

		    	return lum;
			    // v += tri(st.x/3.14);
			    // v=sin(st.x*3.14);

		    	lum = 1 - abs(st.y - v);
		    	// lum = pow(lum,200);
		    	return lum;


		    	st-=.5;
		    	st*=10;
		    	float a = asin(st.x)/st.y;
		    	// lum = 1-abs(3.14 - a);
		    	// lum= 1-abs(st.y - sin(st.x*3.14));
		    	float lhs = asin(st.y);
		    	float rhs = tri((st.x*st.y +st.x*2+st.y));
		    	rhs = rhs*2-1;
		    	rhs *= 3.14159/2;

		    	// lhs =st.y;
		    	// rhs=sin(st.x*3.14*2);

		    	lum=1-abs(lhs - rhs);
		    	// lum=1-abs((lhs-rhs)%1.5);
		    	// lum=sin(st.x);
		    	lum=pow(lum,5);
		    	lum = saturate(lum);
		    	float2 qq = i.uv;
		    	qq -=.5;
		    	qq*=2;
		    	float ww = saturate(1 - distance(qq.x, 0));
		    	ww = pow(ww, 300);
		    	float ee = saturate(1 - distance(qq.y, 0));
		    	ee = pow(ee, 300);
		    	lum += saturate(ww + ee);
		    	return lum;

		    	// lum = 1 - (st.y/st.x)%.2;
		    	// st*=10;
		    	// st=frac(st);
		    	// lum = pow(lum,20);
		    	// st -= .5;
		    	// st *= 2;

		    	// float theta = atan2(st.y, st.x);
		    	// theta += 3.14;
		    	// float spikes = 7;
		    	// lum = theta % (2*3.14/spikes);
		    	// lum /= (2*3.14/spikes);
		    	// lum = max(lum, 1 - lum);
		    	// // lum = (3.14/4) - lum;
		    	// // lum = 1 - distance(.2, length(st%.2));
		    	// lum = pow(lum, 50);
		    	// return lum;
		    	// return 1 - length(st);
		    }

			fixed4 frag (v2f i) : SV_Target
			{
				return shapingGrounds(i);
				fixed4 blah = s01Random(i.uv);
				fixed4 c = cursor(i.uv);
				// return c.a;
				blah.rgb = saturate(blah.rgb);
				blah.rgb = lerp(blah.rgb, c.rgb, c.a);
				return blah;

				// return test(i);
				return test2(i);
				float2 st = i.uv;
				st.y *= _ScreenParams.y / _ScreenParams.x;
				fixed4 col;
				col.a = 1;
				float answer = 0;

				// TILE

				// i want
				// f(0) = 0
				// f(40) = 1
				// f(60) = 1->0
				// f(100) = 1
				// start from the middle, move to the left

				float margin = .25;

				float qq = st;
				qq *= rcSize - margin;
				// qq += margin / 2;
				qq = frac(qq);


				st *= rcSize - margin;
				st += margin / 2;
				st = frac(st);
				st -= .5;
				st = abs(st);
				st *= 2;
				st /= 1-margin;
				st = step(st, 1) * st;

				// st.x =
				// col.rgb = f3(st.x * st.y);

				col.rgb = f3(st,0);
				if (st.x > .98) {
					// col.g = 0;
				}
				if (qq > .99) {
					col.rgb = 1;
				}
				if (qq < .01) {
					col.rgb = float3(0,0,1);
				}
				return col;
				// END TILE

				// SINGLE CHING HEX SQUARE
				st.y *= 4;
				float2 rc = floor(st);
				st = frac(st);

				if (rc.y != 0)
				{
					answer += step(st.y, .1);
				}
				if (rc.y != 3)
				{
					answer += step(.9, st.y);
				}
				answer = saturate(answer);

				int count = floor(_Time.z) % 16;
				if ((count & 0x1) == 0x1 && rc.y == 0 ||
					(count & 0x2) == 0x2 && rc.y == 1 ||
					(count & 0x4) == 0x4 && rc.y == 2 ||
					(count & 0x8) == 0x8 && rc.y == 3)
				{
					answer +=
						step(.5 - .125, st.x) * step(st.x, .5 + .125);
				}
				// END CHING HEX

				// BEGIN RESOLUTION

				// Variables:
				// # of rows & cols
				// x & y margins
				// margin at frame edge?
				// width & height of tiles
				// x & y frame padding

				// tileSize.x = tileSize.y
				// rcSize.x = 10
				// rcSize.y = 5
				// bFrameMargins = 0
				// frameSize = uv;
				// tileMargins = 2/5 * tileSize
				// framePadding?
				// tileSize?

				// float2 frameSize =
				// 	tileSize * rcSize +
				// 	tileMargins * (rcSize - 2 * bFrameMargins) +
				// 	framePadding * 2;
				// float2 rcSize;
				// float2 tileMargins;
				// float bFrameMargins;
				// float2 tileSize;
				// float2 framePadding;

				// tileSize = (frameSize - (tileMargins * (rcSize - 2 * bFrameMargins) +
				// 	framePadding * 2)) / rcSize;
				// framePadding = (frameSize - (tileSize * rcSize +
				// 	tileMargins * (rcSize - 2 * bFrameMargins))) / 2;

				// frameSize = tileSize * rcSize + tileMargins

				// frameSize = tileSize * rcSize + tileMargin * (rcSize - 2) + framePadding * 2
				// framePadding = (frameSize - tileSize * rcSize - tileMargin * (rcSize - 2)) / 2
				// framePadding = (frameSize - tileSize * rcSize - rcSize * marginCoef * (rcSize - 2)) / 2

				// tileSize.y = (frameSize.y - tileMargin.y * (rcSize.y - 2)) / rcSize.y
				// tileSize.x = tileSize.y
				// framePadding.x = (frameSize - tileSize * rcSize - rcSize * marginCoef * (rcSize - 2)) / 2

				// tileMargin = (frameSize - tileSize * rcSize - framePadding * 2) / (rcSize - 2)

				// st = invlerp(framePadding, frameSize - framePadding, stFrame);
				// st = saturate(st)
				// st =

				// END RESOLUTION

				col.rgb = f3(answer);
				return col;
			}
			ENDCG
		}
	}
}
