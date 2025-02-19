Shader "Custom/valueNoise"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Size("Size", Range(0,256)) = 8
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        float random (float2 p){
                return frac(sin(dot(p,float2(12.9898,78.233))) * 43758.5453);
            }

        float valueNoise(float2 st){
                //���͒l�̐�����p�Ə�����f���擾
                float2 p = floor(st);
                float2 f = frac(st);

                //�l���̃m�C�Y��random�֐��Ŏ擾
                float v00 = random(p+float2(0,0));
                float v10 = random(p+float2(1,0));
                float v01 = random(p+float2(0,1));
                float v11 = random(p+float2(1,1));

                //������f���g�������炩�ȋȐ������Ԓlu����肾��
                float2 u = f * f * (3.0 - 2.0 * f);

                //�㑤��x���W�ŕ�Ԃ��̂P
                float2 v0010 = lerp(v00,v10,u.x);
                //������x���W�ŕ�Ԃ��̂Q
                float2 v0111 = lerp(v01,v11,u.x);

                //�����y���W�ŕ⊮���邱�ƂŃp�[�����m�C�Y����������
                return lerp(v0010, v0111, u.y);
            }

        float _Size;
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float c = valueNoise(IN.uv_MainTex*_Size);

            o.Albedo = float4(c,c,c,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
