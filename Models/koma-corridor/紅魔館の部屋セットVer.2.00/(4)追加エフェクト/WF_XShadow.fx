////////////////////////////////////////////////////////////////////////////////////////////////
//
//  WF_XShadow.fx ver0.0.1  X�V���h�[�`��
//  ( WorkingFloorX.fx ����Ăяo����܂��D�I�t�X�N���[���`��p)
//  �쐬: �j��P( ���͉��P����full.fx����,mqdl����xshadow.fx�Q�l )
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �����̃p�����[�^��ύX���Ă�������
float BoneMaxHeight = 6.0;    // X�V���h�[���`�悳��鑫��{�[���̍ő卂��(���f���T�C�Y�ŕϓ��L��)
float XShadowSize = 1.2;      // X�V���h�[�̃T�C�Y
float XShadowAlpha = 0.6;     // X�V���h�[�̓��ߓx
float XShadowZOffset = -0.3;  // X�V���h�[�̑O������ʒu�␳�l

#define ConstSize    0   // ���f���̑傫���ɂ��X�V���h�[�T�C�Y�̎����������s��Ȃ��ꍇ�͂�����1�ɂ���
#define ConstDensity 0   // ���C�g�̏Ɠx�ɂ��X�V���h�[�Z�x�̎����������s��Ȃ��ꍇ�͂�����1�ɂ���


// ����Ȃ��l�͂������牺�͂�����Ȃ��ł�

////////////////////////////////////////////////////////////////////////////////////////////////

// ���{�[���p�����[�^
float4x4 AnkleWldMatR : CONTROLOBJECT < string name = "(self)"; string item = "�E����"; >;
float4x4 AnkleWldMatL : CONTROLOBJECT < string name = "(self)"; string item = "������"; >;
static float3 FootPosR = AnkleWldMatR._41_42_43;
static float3 FootPosL = AnkleWldMatL._41_42_43;
static float rotR = atan2(AnkleWldMatR._13, AnkleWldMatR._33);
static float rotL = atan2(AnkleWldMatL._13, AnkleWldMatL._33);

#if(ConstSize == 0)
float3 KneeWldMatR : CONTROLOBJECT < string name = "(self)"; string item = "�E�Ђ�"; >;
float3 KneeWldMatL : CONTROLOBJECT < string name = "(self)"; string item = "���Ђ�"; >;
float3 LegWldMatR : CONTROLOBJECT < string name = "(self)"; string item = "�E��"; >;
float3 LegWldMatL : CONTROLOBJECT < string name = "(self)"; string item = "����"; >;
static float FootLenR = (length(FootPosR - KneeWldMatR) + length(KneeWldMatR - LegWldMatR)) / 9.42f;
static float FootLenL = (length(FootPosL - KneeWldMatL) + length(KneeWldMatL - LegWldMatL)) / 9.42f;
#else
float FootLenR = 1.0f;
float FootLenL = 1.0f;
#endif

// �l�^�łȂ����f����X�e���\���ɂ���t���O
static float PmdType = (abs(FootPosR.x)+abs(FootPosR.y)+abs(FootPosL.x)+abs(FootPosL.y) > 0.0f) ? 1.0f : 0.0f;

// ���W�ϊ��s��
float4x4 ViewProjMatrix : VIEWPROJECTION;

#if(ConstDensity == 0)
float3 LightAmbient : AMBIENT  < string Object = "Light"; >;
static float BrightNess = 0.5f + max( (LightAmbient.r+LightAmbient.g+LightAmbient.b)*0.55f, 0.0f );
#else
float BrightNess = 1.5f;
#endif

texture2D XShadowTex1 <
    string ResourceName = "XShadow1.png";
>;
sampler XShadowSamp1 = sampler_state {
    texture = <XShadowTex1>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

texture2D XShadowTex2 <
    string ResourceName = "XShadow2.png";
>;
sampler XShadowSamp2 = sampler_state {
    texture = <XShadowTex2>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

// MMD�{����sampler���㏑�����Ȃ����߂̋L�q�ł��B�폜�s�B
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);

////////////////////////////////////////////////////////////////////////////////////////////////
// ���W��2D��]
float3 Rotation2D(float3 pos, float rot)
{
    float x = pos.x * cos(rot) - pos.z * sin(rot);
    float z = pos.x * sin(rot) + pos.z * cos(rot);

    return float3(x, pos.y, z);
}

///////////////////////////////////////////////////////////////////////////////////////////////
// X�e�`��

struct VS_OUTPUTX {
    float4 Pos        : POSITION;    // �ˉe�ϊ����W
    float2 Tex        : TEXCOORD0;   // �e�N�X�`��
    float4 Color      : COLOR0;      // ���l
};

// �E��X�e�`��
VS_OUTPUTX XShadowR1_VS(float4 Pos : POSITION, float2 Tex : TEXCOORD)
{
    VS_OUTPUTX Out = (VS_OUTPUTX)0;

    Pos.z = Pos.y;
    Pos.y = 0.0f;
    Pos.w = 1.0f;
    Pos.xyz *= 7.0f*XShadowSize*FootLenR*PmdType;

    float3 offset = Rotation2D( float3(0.0f, 0.0f, XShadowZOffset*FootLenR), rotR );

    Pos.x += FootPosR.x + offset.x;
    Pos.z += FootPosR.z + offset.z;

    Out.Pos = mul( Pos, ViewProjMatrix );

    float alpha = ( 1.0f - saturate((FootPosR.y-1.0f)/(BoneMaxHeight-1.0f)/FootLenR) ) * XShadowAlpha;
    Out.Color = float4(alpha, alpha, alpha, 1.0f);

    Out.Tex = Tex;

    return Out;
}

// �E��X�e���S�`��
VS_OUTPUTX XShadowR2_VS(float4 Pos : POSITION, float2 Tex : TEXCOORD)
{
    VS_OUTPUTX Out = (VS_OUTPUTX)0;

    Pos.z = Pos.y;
    Pos.y = 0.0f;
    Pos.w = 1.0f;
    Pos.xyz *= 0.9f*XShadowSize*FootLenR*PmdType;

    float3 offset = Rotation2D( float3(0.0f, 0.0f, XShadowZOffset*FootLenR), rotR );

    Pos.x += FootPosR.x + offset.x;
    Pos.z += FootPosR.z + offset.z;

    Out.Pos = mul( Pos, ViewProjMatrix );

    float alpha = ( 1.0f - saturate((FootPosR.y-1.5f)/(BoneMaxHeight-1.5f)/FootLenR) ) * XShadowAlpha;
    Out.Color = float4(alpha, alpha, alpha, 1.0f);

    Out.Tex = Tex;

    return Out;
}

// ����X�e�`��
VS_OUTPUTX XShadowL1_VS(float4 Pos : POSITION, float2 Tex : TEXCOORD)
{
    VS_OUTPUTX Out = (VS_OUTPUTX)0;

    Pos.z = Pos.y;
    Pos.y = 0.0f;
    Pos.w = 1.0f;
    Pos.xyz *= 7.0f*XShadowSize*FootLenL*PmdType;

    float3 offset = Rotation2D( float3(0.0f, 0.0f, XShadowZOffset*FootLenL), rotL );

    Pos.x += FootPosL.x + offset.x;
    Pos.z += FootPosL.z + offset.z;

    Out.Pos = mul( Pos, ViewProjMatrix );

    float alpha = ( 1.0f - saturate((FootPosL.y-1.0f)/(BoneMaxHeight-1.0f)/FootLenL) ) * XShadowAlpha;
    Out.Color = float4(alpha, alpha, alpha, 1.0f);

    Out.Tex = Tex;

    return Out;
}

// ����X�e���S�`��
VS_OUTPUTX XShadowL2_VS(float4 Pos : POSITION, float2 Tex : TEXCOORD)
{
    VS_OUTPUTX Out = (VS_OUTPUTX)0;

    Pos.z = Pos.y;
    Pos.y = 0.0f;
    Pos.w = 1.0f;
    Pos.xyz *= 0.9f*XShadowSize*FootLenL*PmdType;

    float3 offset = Rotation2D( float3(0.0f, 0.0f, XShadowZOffset*FootLenL), rotL );

    Pos.x += FootPosL.x + offset.x;
    Pos.z += FootPosL.z + offset.z;

    Out.Pos = mul( Pos, ViewProjMatrix );

    float alpha = ( 1.0f - saturate((FootPosL.y-1.5f)/(BoneMaxHeight-1.5f)/FootLenL) ) * XShadowAlpha;
    Out.Color = float4(alpha, alpha, alpha, 1.0f);

    Out.Tex = Tex;

    return Out;
}


// �s�N�Z���V�F�[�_
float4 XShadow1_PS(VS_OUTPUTX IN) : COLOR0
{
   float4 Color = tex2D( XShadowSamp1, IN.Tex );
   float3 Color1 = float3(1.0f, 1.0f ,1.0f);
   Color.xyz = Color1 - ( Color1 - Color.xyz ) * IN.Color.xyz;
   Color.xyz = saturate( 1.0f - (1.0f - Color.xyz ) * BrightNess );
   return Color;
}

float4 XShadow2_PS(VS_OUTPUTX IN) : COLOR0
{
   float4 Color = tex2D( XShadowSamp2, IN.Tex );
   float3 Color1 = float3(1.0f, 1.0f ,1.0f);
   Color.xyz = Color1 - ( Color1 - Color.xyz ) * IN.Color.xyz;
   Color.xyz = saturate( 1.0f - (1.0f - Color.xyz ) * BrightNess );
   return Color;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// �e�N�j�b�N
technique MainTec0 < string MMDPass = "object"; string Subset = "0"; >
{
    pass DrawXShadowR1 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowR1_VS();
        PixelShader  = compile ps_2_0 XShadow1_PS();
    }
    pass DrawXShadowR2 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowR2_VS();
        PixelShader  = compile ps_2_0 XShadow2_PS();
    }
    pass DrawXShadowL1 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowL1_VS();
        PixelShader  = compile ps_2_0 XShadow1_PS();
    }
    pass DrawXShadowL2 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowL2_VS();
        PixelShader  = compile ps_2_0 XShadow2_PS();
    }
}

technique MainTec1 < string MMDPass = "object_ss"; string Subset = "0"; >
{
    pass DrawXShadowR1 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowR1_VS();
        PixelShader  = compile ps_2_0 XShadow1_PS();
    }
    pass DrawXShadowR2 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowR2_VS();
        PixelShader  = compile ps_2_0 XShadow2_PS();
    }
    pass DrawXShadowL1 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowL1_VS();
        PixelShader  = compile ps_2_0 XShadow1_PS();
    }
    pass DrawXShadowL2 < string Script= "Draw=Buffer;"; > {
        ZENABLE = FALSE;
        AlphaBlendEnable = TRUE;
        SrcBlend = DESTCOLOR;
        DestBlend = ZERO;
        VertexShader = compile vs_2_0 XShadowL2_VS();
        PixelShader  = compile ps_2_0 XShadow2_PS();
    }
}

technique MainTec2 < string MMDPass = "object"; > { }
technique MainTec3 < string MMDPass = "object_ss"; > { }

//�G�b�W��n�ʉe�͕`�悵�Ȃ�
technique EdgeTec < string MMDPass = "edge"; > { }
technique ShadowTec < string MMDPass = "shadow"; > { }
technique ZplotTec < string MMDPass = "zplot"; > { }

