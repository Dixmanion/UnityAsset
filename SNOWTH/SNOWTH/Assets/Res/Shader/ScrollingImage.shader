Shader "Custom/ScrollingImage" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_xRcrollingSpeed("_xRcrollingSpeed", float) = 1
		_yRcrollingSpeed("_yRcrollingSpeed", float) = 1
	}

	SubShader {
		
		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			float2 uv_MainTex;
		};


		sampler2D _MainTex;
		float _xRcrollingSpeed;
		float _yRcrollingSpeed;
		

		void surf (Input IN, inout SurfaceOutput o) {
			float2 sourceUV = IN.uv_MainTex;

			float xRcrollingSpeed = _xRcrollingSpeed * _Time.y;
			float yRcrollingSpeed = _yRcrollingSpeed * _Time.y;

			sourceUV += float2(xRcrollingSpeed, yRcrollingSpeed);

			float4 c = tex2D(_MainTex, sourceUV);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
