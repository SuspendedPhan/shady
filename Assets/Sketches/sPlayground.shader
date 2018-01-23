Shader "Playground"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			#include "s02Noise.cginc"
			#include "s03NoiseBall.cginc"
			#include "sShapingGrounds.cginc"

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 blah = s03NoiseBall(i.uv);
				fixed4 c = cursor(i.uv);
				blah.rgb = saturate(blah.rgb);
				blah.rgb = lerp(blah.rgb, c.rgb, c.a);
				return blah;
			}
			ENDCG
		}
	}
}
