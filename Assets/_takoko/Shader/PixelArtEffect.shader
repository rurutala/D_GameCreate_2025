Shader "Custom/PixelArtEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PixelSize ("Pixel Size", Range(1, 20)) = 6
        _ColorSteps ("Color Steps", Range(2, 32)) = 8
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _PixelSize;
            float _ColorSteps;

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pixelSize = _PixelSize * _MainTex_TexelSize.xy;
                float2 uv = floor(i.uv / pixelSize) * pixelSize + (pixelSize * 0.5);

                fixed4 col = tex2D(_MainTex, uv);

                col.rgb = floor(col.rgb * _ColorSteps) / _ColorSteps;

                return col;
            }
            ENDCG
        }
    }
}
