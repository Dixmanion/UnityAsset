Shader "Custom/BurnDissolve" {
	Properties {
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_SliceGuide ("Slice Guide (RGB)", 2D) = "white" {}
		_SliceAmount ("Slice Amount", Range(0.0, 1.0)) = 0.5

		_BurnSize("Burn Size", Range(0, 1.0)) = 0.15
		_BurnRamp("Burn Ramp(RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "IgnoreProjector" = "True"}
		LOD 200
		


		Pass
		{
			Cull off
			Lighting off
			ZWrite off
			Fog { Mode Off }
			Offset -1,-1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _MainTex;
			sampler2D _SliceGuide;
			float _SliceAmount;
			float _BurnSize;
			sampler2D _BurnRamp;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				fixed grey : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				float4 worldpos = mul(_Object2World, v.vertex);
				o.grey = 1 - step(0,worldpos.z);
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				half4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
				half alpha = tex2D(_SliceGuide, IN.texcoord).rgb - _SliceAmount; // rgb是否超过要求的_SliceAmount
				col.a = 1 - step(tex2D(_SliceGuide, IN.texcoord).rgb - _SliceAmount, 0);
				half4 emission = tex2D(_BurnRamp, float2(alpha*(1/_BurnSize), 0));
				col.rgb *= lerp(emission, 1, 1-step(alpha, _BurnSize));
				return col;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
