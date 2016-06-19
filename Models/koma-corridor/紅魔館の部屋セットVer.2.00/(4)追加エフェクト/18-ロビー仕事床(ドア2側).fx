////////////////////////////////////////////////////////////////////////////////////////////////
//
//  WorkingFloorX.fx ver0.0.2  �I�t�X�N���[�������_���g�������ʋ����`�� & X�V���h�[�`��
//  �쐬: �j��P( ���͉��P����Mirror.fx, full.fx,���� )
//
////////////////////////////////////////////////////////////////////////////////////////////////
#define UseMirror  1    // X�e�݂̂ŏ��ʋ����`����g��Ȃ��ꍇ�͂�����0�ɂ���

#if(UseMirror == 1)
// ���ʋ����`��̃I�t�X�N���[���o�b�t�@
texture WorkingFloorRT : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for WorkingFloorX.fx";
    float2 ViewPortRatio = {1.0,1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    bool AntiAlias = true;
    string DefaultEffect = 
        "self = hide;"

//********** �����ɋ����`�悳����I�u�W�F�N�g���w�肵�Ă������� **********

	"�g���ق̕���(��{����1).pmx = hide;"
	"�g���ق̕���(�ǉ�����1).pmx = hide;"
	"�g���ق̕���(�����p�L��1).pmx = hide;"
	"�g���ق̕���(��{����2).pmx = hide;"
	"�g���ق̕���(�ǉ�����2).pmx = hide;"
	"�g���ق̕���(�����p�L��2).pmx = hide;"
	"�x�b�h.pmx = hide;"
	"13-�g���ك��r�[(�h�A1��).x = hide;"
	"13-�g���ك��r�[(�h�A2��).x = hide;"
	"14-���r�[�O��(�h�A1��).x = hide;"
	"14-���r�[�O��(�h�A2��).x = hide;"
	"*.x = WF_Object.fx;"
        "*.pmd = WF_Object.fx;"
        "*.pmx = WF_Object.fx;"
        "*.vac = WF_Object.fx;"

//************************************************************************

        "* = hide;" 
    ;
>;

// ����Ȃ��l�͂������牺�͂�����Ȃ��ł�

////////////////////////////////////////////////////////////////////////////////////////////////
sampler WorkingFloorView = sampler_state {
    texture = <WorkingFloorRT>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};
#endif

// X�e�`��Ɏg���I�t�X�N���[���o�b�t�@
texture FloorXShadowRT : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for XShadow of WorkingFloorX.fx";
    float2 ViewPortRatio = {1.0,1.0};
    float4 ClearColor = { 1, 1, 1, 1 };
    float ClearDepth = 1.0;
    bool AntiAlias = true;
    string DefaultEffect = 
        "self = hide;"
        "*.pmd = WF_XShadow.fx;"
        "*.pmx = WF_XShadow.fx;"
        "*.x = hide;" 
        "* = hide;" 
    ;
>;
sampler XShadowSmp = sampler_state {
    texture = <FloorXShadowRT>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};

// ���W�ϊ��s��
float4x4 WorldMatrix    : WORLD;
float4x4 ViewProjMatrix : VIEWPROJECTION;

// �}�e���A���F
float4 MaterialDiffuse : DIFFUSE  < string Object = "Geometry"; >;
static float AcsAlpha = MaterialDiffuse.a;

// �X�N���[���T�C�Y
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = (float2(0.5f, 0.5f)/ViewportSize);

////////////////////////////////////////////////////////////////////////////////////////////////
struct VS_OUTPUT {
    float4 Pos  : POSITION;
    float4 VPos : TEXCOORD1;
};

// ���ʂ̒��_�V�F�[�_
VS_OUTPUT VS_Common(float4 Pos : POSITION)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

    Pos = mul( Pos, WorldMatrix );
    Pos.y += 0.01f;
    Pos = mul( Pos, ViewProjMatrix );

    Out.Pos = Pos;
    Out.VPos = Pos;

    return Out;
}

// ���ʋ����`��
#if(UseMirror == 1)
float4 PS_Mirror(VS_OUTPUT IN) : COLOR
{
    // �����̃X�N���[���̍��W(���E���]���Ă���̂Ō��ɖ߂�)
    float2 texCoord = float2( 1.0f - ( IN.VPos.x/IN.VPos.w + 1.0f ) * 0.5f,
                              1.0f - ( IN.VPos.y/IN.VPos.w + 1.0f ) * 0.5f ) + ViewportOffset;

    // �����̐F
    float4 Color = tex2D(WorkingFloorView, texCoord);
    Color.a *= AcsAlpha;

    return Color;
}
#endif

// X�e�`��
float4 PS_XShadow(VS_OUTPUT IN) : COLOR
{
    // X�e�̃X�N���[���̍��W
    float2 texCoord = float2( ( IN.VPos.x/IN.VPos.w + 1.0f ) * 0.5f,
                              1.0f - ( IN.VPos.y/IN.VPos.w + 1.0f ) * 0.5f ) + ViewportOffset;
    float4 Color = tex2D(XShadowSmp, texCoord);
    Color.a = 1.0f - Color.r;
    Color.xyz = float3(0.0f ,0.0f ,0.0f);

    return Color;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//�e�N�j�b�N

technique MainTec{
#if(UseMirror == 1)
    pass DrawObject{
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_Mirror();
    }
#endif
    pass DrawXShadow{
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_XShadow();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////



