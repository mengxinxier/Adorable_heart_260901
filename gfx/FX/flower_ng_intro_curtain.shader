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
			float radial = saturate( length( float2( centered.x * 0.88f, centered.y * 0.94f ) ) * 0.72f );

			float u = smoothstep( 0.0f, 0.88f, t );
			float quint = u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
			float baseReveal = 1.0f - quint;

			float cloud = ( drv.r * 0.62f + drv.g * 0.38f ) - 0.5f;
			float centerLead = lerp( 0.86f, 1.12f, radial ) + cloud * 0.20f;
			float tailZero = 1.0f - smoothstep( 0.82f, 0.94f, t );
			float alpha = saturate( 0.86f * baseReveal * centerLead ) * tailZero;

			float3 velvetInk = lerp( float3( 0.015f, 0.017f, 0.025f ), float3( 0.042f, 0.038f, 0.058f ), drv.g );
			float3 softWarm = float3( 0.075f, 0.064f, 0.052f ) * ( 1.0f - radial ) * ( 1.0f - quint ) * drv.r;
			float3 col = saturate( velvetInk + softWarm );

			return float4( col, alpha ) * Color;
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
