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
			#include "sToolbox.cginc"

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

			float3 f3(float x) { return float3(x, x, x); }
			float3 f3(float2 x, float y) { return float3(x.x, x.y, y); }
			float2 invlerp(float x, float y, float2 t)
			{
				return (t - x) / (y - x);
			}
			float2 rotate(float2 st, float angle)
			{
			    st -= 0.5;
			    st = mul(float2x2(cos(angle),-sin(angle),
					sin(angle),cos(angle)), st);
			    st += 0.5;
			    return st;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 st = i.uv;
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

				float qq = frac(st.x * rcSize);
				float margin = .25;

				st *= rcSize - margin;
				st += margin / 2;
				st = frac(st);
				st -= .5;
				st = abs(st);
				st *= 2;
				st /= 1-margin;
				st = step(st, 1) * st;
				// col.rgb = f3(st.x * st.y);

				col.rgb = f3(st,0);
				if (st.x > .98) {
					// col.g = 0;
				}
				if (qq > .995) {
					// col.rgb = float3(0, 1, 1);
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
