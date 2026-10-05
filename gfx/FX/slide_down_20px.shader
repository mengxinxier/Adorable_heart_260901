# ########
# Adorable Heart - click-toggle slide shader
# ########
# slide_down_20px.shader   [state = 0]
#
# 控件显示时从 +20px（向上）滑回 0px，停在“未选中/原位”位置。对应 ROC_coin_box_icon_1_down。
#
# 时钟来源 : sprite 必须是 frameAnimatedSpriteType（见 interface/ICON_ROC.gfx）
#            + play_on_show = yes。引擎在控件每次显示时会重放这段伪动画：
#              Offset.x      = 当前帧 / 总帧数      (0 或 0.5)
#              AnimationTime = 当前帧内的过渡系数   (0 -> 1)
#            两者合成得到整段 0..1 的进度。
#            不能用 (Time - AnimationTime)：对普通 sprite 而言 AnimationTime 是
#            “上次按下按钮的时刻”，靠 triggers._visible 显隐并不会重置它，
#            结果 t 直接饱和到 1，看起来就是瞬间到位。
#
# 调速     : 改 .gfx 里的 animation_rate_fps（越小越慢，2 帧 no-loop 约 1/fps 秒）
# 距离     : 改下面的 SLIDE_PIXELS
# ########

Includes = {
	"buttonstate.fxh"        // WorldViewProjectionMatrix / Color / Offset / NextOffset / Time / AnimationTime
}

PixelShader =
{
	Samplers =
	{
		MapTexture =
		{
			Index = 0
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Clamp"
		}
	}
}

VertexStruct VS_OUTPUT
{
	float4 vPosition : PDX_POSITION;
	float2 vTexCoord : TEXCOORD0;
};

VertexShader =
{
	MainCode VertexShader
	[[
		// 必须和 .gfx 里的 noOfFrames 一致
		static const float NO_OF_FRAMES = 2.0;
		static const float SLIDE_PIXELS = 20.0;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;

			// 帧序号 + 帧内过渡 => 整段 0..1 进度，再归一到 [0,1]
			float t = ( Offset.x + AnimationTime / NO_OF_FRAMES )
			        * ( NO_OF_FRAMES / ( NO_OF_FRAMES - 1.0 ) );
			t = saturate( t );
			t = t * t * ( 3.0 - 2.0 * t );

			// 本控件是“原位”状态：最终停在 0px，从 +20px 滑下来。
			float yOffset = lerp( SLIDE_PIXELS, 0.0, t );

			// UI 本地空间~像素；偏移必须在乘 WVP 之前加。
			// 实测 HOI4 UI 顶点本地坐标里 +y 为“向上”，与 .gui 的 y 方向相反。
			float3 pos = v.vPosition;
			pos.y += yOffset;

			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1 ) );
			// 2 帧图集：vTexCoord 是帧内 UV，加上 Offset 才落到当前帧
			Out.vTexCoord = v.vTexCoord + Offset;
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 c = tex2D( MapTexture, v.vTexCoord );
			c *= Color;
			return c;
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend   = "INV_SRC_ALPHA"
}

Effect Up      { VertexShader = "VertexShader"  PixelShader = "PixelShader" }
Effect Down    { VertexShader = "VertexShader"  PixelShader = "PixelShader" }
Effect Disable { VertexShader = "VertexShader"  PixelShader = "PixelShader" }
Effect Over    { VertexShader = "VertexShader"  PixelShader = "PixelShader" }
