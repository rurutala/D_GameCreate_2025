Shader "Custom/ToonAndOutline"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0.0, 0.0, 0.0, 1)
        [Slider(0.1)] _OutlineWidth("Outline Width", Range(0.0, 100.0)) = 3
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        // 【1パス目】アウトライン用のダミー色描画
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
            };

            struct v2f
            {
                half4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(1.0, 0.0, 1.0, 0);
            }
            ENDCG
        }

        GrabPass {}

        // 【2パス目】アウトラインとトゥーンシェーディング
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define SAMPLE_NUM 6
            #define SAMPLE_INV 0.16666666
            #define PI2 6.2831852
            #define EPSILON 0.001
            #define DUMMY_COLOR fixed3(1.0, 0.0, 1.0)

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
                half4 grabPos : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;
            };

            sampler2D _GrabTexture;
            sampler2D _MainTex;
            sampler2D _RampTex;
            fixed4 _MainColor;
            fixed4 _OutlineColor;
            half _OutlineWidth;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half2 delta = (1 / _ScreenParams.xy) * _OutlineWidth;

                int edge = 0;
                [unroll]
                for (int j = 0; j < SAMPLE_NUM && edge == 0; j++)
                {
                    fixed4 tex = tex2D(_GrabTexture, i.grabPos.xy / i.grabPos.w + half2(sin(SAMPLE_INV * j * PI2) * delta.x, cos(SAMPLE_INV * j * PI2) * delta.y));
                    edge += distance(tex.rgb, DUMMY_COLOR) < EPSILON ? 0 : 1;
                }

                half3 normal = normalize(i.worldNormal);
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = dot(normal, lightDir);
                half3 toonRamp = tex2D(_RampTex, float2(NdotL * 0.49 + 0.5, 0.5)).rgb;

                fixed4 toonColor = tex2D(_MainTex, i.uv) * _MainColor;
                toonColor.rgb *= toonRamp;

                fixed4 col = lerp(toonColor, _OutlineColor, edge);
                return col;
            }
            ENDCG
        }
    }
}
