Shader "Custom/ToonAndInvisible"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _TopViewThreshold("Top View Threshold", Range(0.0, 1.0)) = 0.8
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 worldNormal : TEXCOORD1;
                half3 viewDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            sampler2D _RampTex;
            fixed4 _MainColor;
            float4 _MainTex_ST;
            half _TopViewThreshold;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half3 normal = normalize(i.worldNormal);
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = dot(normal, lightDir);
                half3 toonRamp = tex2D(_RampTex, float2(NdotL * 0.45 + 0.5, 0.5)).rgb;

                fixed4 toonColor = tex2D(_MainTex, i.uv) * _MainColor;
                toonColor.rgb *= toonRamp;

                // 視線方向と法線の向きを考慮して上からも下からも透明化
                half viewNormalDot = dot(normal, i.viewDir);
                half visibilityFactor = abs(viewNormalDot); // 上向き・下向きを考慮
                clip(_TopViewThreshold - visibilityFactor); // 閾値を超えたら破棄

                return toonColor;
            }
            ENDCG
        }
    }
}
