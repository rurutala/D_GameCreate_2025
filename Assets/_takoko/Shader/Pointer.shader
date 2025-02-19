Shader "Custom/Pointer" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp", 2D) = "white"{}
        _StripeColor ("Stripe Color", Color) = (0,0,0,1)
        _StripeFrequency ("Stripe Frequency", Float) = 10.0
        _StripeSpeed ("Stripe Speed", Float) = 1.0
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf ToonRamp alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        fixed4 _Color;
        fixed4 _StripeColor;
        float _StripeFrequency;
        float _StripeSpeed;
        float _Cutoff;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
            float3 viewDir;
        };

        fixed4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten) {
            half d = dot(s.Normal, lightDir) * 0.49 + 0.5;
            fixed3 ramp = tex2D(_RampTex, fixed2(d, 0.5)).rgb;
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            
            // ŠÔŒo‰ß‚Å“®‚­ x ²•ûŒü‚ÌÈ–Í—l‚ÌŒvZ
            float timeFactor = _Time.y * _StripeSpeed;
            float stripePattern = sin(IN.worldPos.y * _StripeFrequency + timeFactor);
            if (stripePattern > 0) {
                o.Albedo = lerp(o.Albedo, _StripeColor.rgb, 0.5);
            }
            
            // “§–¾•”•ª‚Ìˆ—
            clip(o.Alpha - _Cutoff);
        }
        ENDCG
    }
    FallBack "Transparent/Cutout/Diffuse"
}
