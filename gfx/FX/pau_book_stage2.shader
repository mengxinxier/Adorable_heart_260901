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
};

VertexShader =
{
	MainCode VertexShader
	[[
		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		// Mid-chapter watercolor wash (~56%)
		static const float PAINT_STAGE = 0.56f;

		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float2 uv = v.vTexCoord;
			float4 c = tex2D( MapTexture, uv );
			if ( c.a < 0.004f )
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );

			// Synthesize charcoal line-art sketch from local luminance gradients
			float2 e = float2( 0.0022f, 0.0018f );
			float lR = dot( tex2D( MapTexture, saturate( uv + float2(  e.x, 0.0f ) ) ).rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float lL = dot( tex2D( MapTexture, saturate( uv + float2( -e.x, 0.0f ) ) ).rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float lD = dot( tex2D( MapTexture, saturate( uv + float2( 0.0f,  e.y ) ) ).rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float lU = dot( tex2D( MapTexture, saturate( uv + float2( 0.0f, -e.y ) ) ).rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float luma = dot( c.rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float edge = saturate( ( abs( lR - lL ) + abs( lD - lU ) ) * 3.8f );

			float grain = 0.5f + 0.5f * sin( uv.x * 165.0f + uv.y * 95.0f ) * sin( uv.x * 80.0f - uv.y * 140.0f );
			float3 sketchPaper = float3( 0.25f, 0.21f, 0.18f ) + float3( 0.12f, 0.10f, 0.08f ) * luma + float3( 0.02f, 0.018f, 0.014f ) * grain;
			float3 sketchInk = float3( 0.12f, 0.095f, 0.085f );
			float3 sketchRgb = lerp( sketchPaper, sketchInk, edge );
			float sketchAlpha = c.a * ( 0.34f + 0.38f * edge );

			// Organic top-to-bottom watercolor wash frontier with wet dark pigment rim
			float paperWave = 0.5f
			                + 0.28f * sin( uv.x * 9.5f + uv.y * 4.2f )
			                + 0.14f * cos( uv.x * 21.0f - uv.y * 17.0f )
			                + 0.08f * sin( uv.x * 39.0f + uv.y * 31.0f );
			float flowY = saturate( uv.y * 0.78f + 0.11f + ( paperWave - 0.5f ) * 0.16f );
			float cutoff = ( PAINT_STAGE < 0.01f ) ? -0.25f : ( ( PAINT_STAGE > 0.99f ) ? 1.35f : PAINT_STAGE );
			float paintMask = 1.0f - smoothstep( cutoff - 0.11f, cutoff + 0.07f, flowY );

			float frontierActive = smoothstep( 0.02f, 0.10f, PAINT_STAGE ) * ( 1.0f - smoothstep( 0.90f, 0.98f, PAINT_STAGE ) );
			float wetBand = ( 1.0f - smoothstep( 0.0f, 0.09f, abs( flowY - cutoff ) ) ) * frontierActive;
			float shimmer = 0.96f + 0.04f * sin( Time * 0.95f + uv.x * 4.5f - uv.y * 3.1f );

			// Filmic highlight roll-off guarantees white focus text and prerequisite links stay crisp
			float safeScale = ( luma > 0.46f ) ? ( 0.46f + ( luma - 0.46f ) * 0.32f ) / max( luma, 0.001f ) : 1.0f;
			float3 paintRgb = c.rgb * safeScale * shimmer;
			paintRgb = lerp( paintRgb, float3( 0.58f, 0.33f, 0.25f ), wetBand * 0.42f );
			float paintAlpha = c.a * 0.80f;

			float3 finalRgb = lerp( sketchRgb, paintRgb, paintMask );
			float finalAlpha = lerp( sketchAlpha, paintAlpha, paintMask );
			return float4( finalRgb, finalAlpha ) * Color;
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
