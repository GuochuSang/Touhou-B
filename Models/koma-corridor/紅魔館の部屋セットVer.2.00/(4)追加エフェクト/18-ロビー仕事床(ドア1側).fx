////////////////////////////////////////////////////////////////////////////////////////////////
//
//  WorkingFloorX.fx ver0.0.2  オフスクリーンレンダを使った床面鏡像描画 & Xシャドー描画
//  作成: 針金P( 舞力介入P氏のMirror.fx, full.fx,改変 )
//
////////////////////////////////////////////////////////////////////////////////////////////////
#define UseMirror  1    // X影のみで床面鏡像描画を使わない場合はここを0にする

#if(UseMirror == 1)
// 床面鏡像描画のオフスクリーンバッファ
texture WorkingFloorRT : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for WorkingFloorX.fx";
    float2 ViewPortRatio = {1.0,1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    bool AntiAlias = true;
    string DefaultEffect = 
        "self = hide;"

//********** ここに鏡像描画させるオブジェクトを指定してください **********

	"紅魔館の部屋(基本部屋1).pmx = hide;"
	"紅魔館の部屋(追加部屋1).pmx = hide;"
	"紅魔館の部屋(延長用廊下1).pmx = hide;"
	"紅魔館の部屋(基本部屋2).pmx = hide;"
	"紅魔館の部屋(追加部屋2).pmx = hide;"
	"紅魔館の部屋(延長用廊下2).pmx = hide;"
	"ベッド.pmx = hide;"
	"13-紅魔館ロビー(ドア1側).x = hide;"
	"13-紅魔館ロビー(ドア2側).x = hide;"
	"14-ロビー外壁(ドア1側).x = hide;"
	"14-ロビー外壁(ドア2側).x = hide;"
	"*.x = WF_Object.fx;"
        "*.pmd = WF_Object.fx;"
        "*.pmx = WF_Object.fx;"
        "*.vac = WF_Object.fx;"

//************************************************************************

        "* = hide;" 
    ;
>;

// 解らない人はここから下はいじらないでね

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

// X影描画に使うオフスクリーンバッファ
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

// 座標変換行列
float4x4 WorldMatrix    : WORLD;
float4x4 ViewProjMatrix : VIEWPROJECTION;

// マテリアル色
float4 MaterialDiffuse : DIFFUSE  < string Object = "Geometry"; >;
static float AcsAlpha = MaterialDiffuse.a;

// スクリーンサイズ
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = (float2(0.5f, 0.5f)/ViewportSize);

////////////////////////////////////////////////////////////////////////////////////////////////
struct VS_OUTPUT {
    float4 Pos  : POSITION;
    float4 VPos : TEXCOORD1;
};

// 共通の頂点シェーダ
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

// 床面鏡像描画
#if(UseMirror == 1)
float4 PS_Mirror(VS_OUTPUT IN) : COLOR
{
    // 鏡像のスクリーンの座標(左右反転しているので元に戻す)
    float2 texCoord = float2( 1.0f - ( IN.VPos.x/IN.VPos.w + 1.0f ) * 0.5f,
                              1.0f - ( IN.VPos.y/IN.VPos.w + 1.0f ) * 0.5f ) + ViewportOffset;

    // 鏡像の色
    float4 Color = tex2D(WorkingFloorView, texCoord);
    Color.a *= AcsAlpha;

    return Color;
}
#endif

// X影描画
float4 PS_XShadow(VS_OUTPUT IN) : COLOR
{
    // X影のスクリーンの座標
    float2 texCoord = float2( ( IN.VPos.x/IN.VPos.w + 1.0f ) * 0.5f,
                              1.0f - ( IN.VPos.y/IN.VPos.w + 1.0f ) * 0.5f ) + ViewportOffset;
    float4 Color = tex2D(XShadowSmp, texCoord);
    Color.a = 1.0f - Color.r;
    Color.xyz = float3(0.0f ,0.0f ,0.0f);

    return Color;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//テクニック

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



