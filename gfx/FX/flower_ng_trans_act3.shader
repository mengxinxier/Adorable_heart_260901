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
			float sec = t * 3.25f;
			float2 localUV = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float4 drv = tex2D( MapTexture, float2( frameOff + clamp( localUV.x, 0.002f, 0.998f ) * 0.5f, clamp( localUV.y, 0.002f, 0.998f ) ) );
			float2 centered = ( localUV - 0.5f ) * 2.0f;
			float radial = saturate( length( float2( centered.x * 0.90f, centered.y * 0.96f ) ) * 0.72f );
			float cloud = ( drv.r * 0.62f + drv.g * 0.38f ) - 0.5f;

			float u = saturate( ( t - 0.048f ) / ( 0.212f - 0.048f ) );
			float quint = u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
			float reveal = 1.0f - quint;
			float spatialBias = lerp( 1.0f, lerp( 0.92f, 1.08f, radial ) + cloud * 0.08f, quint );
			float tailZero = 1.0f - smoothstep( 0.89f, 0.95f, t );

			float b1 = pulseEnv( sec, 0.10f, 0.16f, 0.90f );
			float b2 = pulseEnv( sec, 0.96f, 0.14f, 0.80f );
			float b3 = pulseEnv( sec, 1.58f, 0.13f, 0.88f );
			float b4 = pulseEnv( sec, 2.02f, 0.12f, 0.94f );
			float b5 = pulseEnv( sec, 2.32f, 0.11f, 0.98f );
			float b6 = pulseEnv( sec, 2.52f, 0.10f, 1.00f );
			float b7 = pulseEnv( sec, 2.68f, 0.18f, 1.00f );
			float winGate = 1.0f - smoothstep( 2.86f, 2.96f, sec );
			float auxBurst = max( max( b2, b3 ), max( max( b4, b5 ), max( b6, b7 ) ) ) * 0.25f * winGate;

			float centerGlow = 1.0f - radial * 0.46f;
			float3 baseCol = lerp( float3( 0.012f, 0.014f, 0.020f ), float3( 0.020f, 0.023f, 0.032f ), drv.g * 0.55f );
			float veilA = saturate( 0.95f * reveal * spatialBias );
			float auxA = auxBurst * ( 0.60f + 0.40f * drv.r ) * ( 0.70f + 0.30f * radial );
			float alpha = saturate( max( veilA, auxA ) ) * tailZero;
			float3 col = baseCol + float3( 0.34f, 0.38f, 0.52f ) * centerGlow * b1;
			col = lerp( col, float3( 0.38f, 0.30f, 0.64f ) * ( 0.68f + 0.32f * drv.g ), saturate( auxA * 4.2f ) * ( 1.0f - veilA ) );
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
