Includes = {
	"buttonstate.fxh"
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
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
	}
}

VertexStruct VS_OUTPUT
{
	float4 vPosition : PDX_POSITION;
	float2 vTexCoord : TEXCOORD0;
	float4 vAnimData : TEXCOORD1;
};

VertexShader =
{
	MainCode VertexShader
	[[
		static const float NO_OF_FRAMES = 2.0f;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			float t = saturate( ( Offset.x + AnimationTime / NO_OF_FRAMES ) * ( NO_OF_FRAMES / ( NO_OF_FRAMES - 1.0f ) ) );
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			Out.vAnimData = float4( v.vTexCoord.x * NO_OF_FRAMES, v.vTexCoord.y, t, Offset.x );
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		float pulseEnv( float sec, float center, float width, float amp )
		{
			float wUp = width * 0.28f;
			float wDn = width * 0.72f;
			return smoothstep( center - wUp, center - wUp * 0.12f, sec )
			     * ( 1.0f - smoothstep( center + wDn * 0.18f, center + wDn, sec ) ) * amp;
		}

		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float t = v.vAnimData.z;
			if ( t >= 0.95f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}
			float sec = t * 3.60f;
			float2 localUV = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float4 drv = tex2D( MapTexture, float2( frameOff + clamp( localUV.x, 0.002f, 0.998f ) * 0.5f, clamp( localUV.y, 0.002f, 0.998f ) ) );
			float2 centered = ( localUV - 0.5f ) * 2.0f;
			float radial = saturate( length( float2( centered.x * 0.90f, centered.y * 0.96f ) ) * 0.72f );
			float cloud = ( drv.r * 0.62f + drv.g * 0.38f ) - 0.5f;

			float u = saturate( ( t - 0.088f ) / ( 0.215f - 0.088f ) );
			float quint = u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
			float reveal = 1.0f - quint;
			float spatialBias = lerp( 1.0f, lerp( 0.92f, 1.08f, radial ) + cloud * 0.08f, quint );
			float tailZero = 1.0f - smoothstep( 0.90f, 0.95f, t );

			float f01 = pulseEnv( sec, 0.08f, 0.12f, 0.92f );
			float f02 = pulseEnv( sec, 0.24f, 0.12f, 0.96f );
			float f03 = pulseEnv( sec, 0.92f, 0.14f, 0.82f );
			float f04 = pulseEnv( sec, 1.28f, 0.13f, 0.88f );
			float f05 = pulseEnv( sec, 1.54f, 0.12f, 0.94f );
			float f06 = pulseEnv( sec, 1.74f, 0.11f, 0.98f );
			float f07 = pulseEnv( sec, 1.88f, 0.10f, 1.00f );
			float f08 = pulseEnv( sec, 2.00f, 0.09f, 1.00f );
			float f09 = pulseEnv( sec, 2.10f, 0.15f, 1.00f );
			float f10 = pulseEnv( sec, 2.92f, 0.14f, 0.96f );
			float winGate = 1.0f - smoothstep( 3.09f, 3.20f, sec );

			float openTwin = max( f01, f02 );
			float flurry = max( max( max( f03, f04 ), max( f05, f06 ) ), max( max( f07, f08 ), max( f09, f10 ) ) );
			float auxV = flurry * 0.27f * winGate;
			float centerGlow = 1.0f - radial * 0.45f;
			float3 baseCol = lerp( float3( 0.008f, 0.009f, 0.014f ), float3( 0.014f, 0.016f, 0.023f ), drv.g * 0.55f );
			float veilA = saturate( 0.96f * reveal * spatialBias );
			float auxA = auxV * ( 0.62f + 0.38f * drv.r ) * ( 0.68f + 0.32f * radial );
			float alpha = saturate( max( veilA, auxA ) ) * tailZero;
			float3 col = baseCol + float3( 0.48f, 0.50f, 0.62f ) * centerGlow * openTwin;
			col = lerp( col, float3( 0.46f, 0.40f, 0.70f ) * ( 0.68f + 0.32f * drv.g ), saturate( auxA * 4.0f ) * ( 1.0f - veilA ) );
			return float4( saturate( col ), saturate( alpha ) ) * Color;
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
}

Effect Up      { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
