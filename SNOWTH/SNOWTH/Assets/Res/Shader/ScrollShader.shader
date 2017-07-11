Shader "Custom/ScrollShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ColorTint("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		_DissolveTex ("Dissolution texture", 2D) = "gray" {}
		
		_ScreenPercent ("Screen Percent", float) = 0.6
		_ShowTime ("Show Time", float) = 0.0
		_ScrollSpeedX ("Scroll Speed X", float) = 1.0
		_DisappearSpeed ("Disappear Speed", float) = 0.4
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull off
			Lighting off
			ZWrite off
			Fog{ Mode Off }
			Blend SrcAlpha OneMinusSrcAlpha

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
			float4 _MainTex_ST;
			sampler2D _DissolveTex;
			fixed4 _ColorTint;
			float _ShowTime;
			float _DisappearSpeed;
			float _ScreenPercent;
			float _ScrollSpeedX;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = o.uv * float2(_ScreenPercent, 1);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				bool endScroll = step(1 - _ScreenPercent, _ScrollSpeedX * _Time.y);
				float2 sourceUV = i.uv + lerp(float2(_ScrollSpeedX * _Time.y, 0), float2((1 - _ScreenPercent), 0), endScroll);

				fixed4 col = tex2D(_MainTex, sourceUV);

				if (_ScrollSpeedX * _Time.y >= ((1 - _ScreenPercent) + _ShowTime)) {
					// 开始处理水墨化消失
					fixed val = 1 - tex2D(_DissolveTex, i.uv * float2(1/_ScreenPercent, 1)).r;
					float timeSinceStartDisappear = _ScrollSpeedX * _Time.y - 1 - _ShowTime + _ScreenPercent;
					if (val < timeSinceStartDisappear - 0.02)
					{
						discard;
					}
					//bool b = val < timeSinceStartDisappear;
					//return lerp(col, col * fixed4(lerp(1, 0, 1 - saturate(abs(timeSinceStartDisappear - val) / 0.02)), 0, 0, 1), b);
				}
				col *= _ColorTint;
				return col;
			}
			ENDCG
		}
	}
}
