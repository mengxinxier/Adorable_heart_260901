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
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float t = v.vAnimData.z;
			if ( t >= 0.95f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}

			float2 localUV = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float2 sampleUV = float2( frameOff + clamp( localUV.x, 0.002f, 0.998f ) * 0.5f, clamp( localUV.y, 0.002f, 0.998f ) );
			float4 drv = tex2D( MapTexture, sampleUV );

			float2 centered = ( localUV - 0.5f ) * 2.0f;
			float radial = saturate( length( float2( centered.x * 0.90f, centered.y * 0.96f ) ) * 0.72f );
			float cloud = ( drv.r * 0.62f + drv.g * 0.38f ) - 0.5f;

			float u = smoothstep( 0.23f, 0.92f, t );
			float quint = u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
			float reveal = 1.0f - quint;
			float spatialBias = lerp( 1.0f, lerp( 0.92f, 1.08f, radial ) + cloud * 0.08f, quint );
			float tailZero = 1.0f - smoothstep( 0.86f, 0.95f, t );

			float silverImpact = ( 1.0f - smoothstep( 0.055f, 0.095f, t ) );
			float centerBright = lerp( 1.0f, 0.34f, smoothstep( 0.12f, 0.95f, radial ) );
			float3 darkVelvet = lerp( float3( 0.008f, 0.007f, 0.012f ), float3( 0.016f, 0.013f, 0.024f ), drv.g * 0.55f );
			float3 coldSilver = float3( 0.78f, 0.83f, 0.94f ) * centerBright + float3( 0.04f, 0.03f, 0.08f );
			float3 col = lerp( darkVelvet, coldSilver, silverImpact );
			float peakAlpha = lerp( 0.95f, 0.86f, silverImpact );
			float alpha = saturate( peakAlpha * reveal * spatialBias ) * tailZero;

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
