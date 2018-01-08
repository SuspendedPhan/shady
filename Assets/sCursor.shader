Shader "sCursor"
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float2 uMouse;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 answer = tex2D(_MainTex, i.uv);
				float2 st = i.uv;
				// st.x -= .5;
				st.x *= _ScreenParams.x / _ScreenParams.y;
				float2 mouse = uMouse;
				// mouse.x -= .5;
				mouse.x *= _ScreenParams.x / _ScreenParams.y;
				float dist = distance(st, mouse);
				float lum = smoothstep(.03, 0, dist);
				answer.rgb += lum;
				return answer;
			}
			ENDCG
		}
	}
}
