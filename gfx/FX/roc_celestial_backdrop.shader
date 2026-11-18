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
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float2 uv = v.vTexCoord;
			float4 c = tex2D( MapTexture, uv );

			// Central sanctuary radial breathing + subtle celestial scanline wave
			float2 d = ( uv - float2( 0.5f, 0.48f ) ) * float2( 1.6f, 1.0f );
			float dist = length( d );
			float halo = exp( -dist * dist * 3.2f );
			float breath = 0.5f + 0.5f * sin( Time * 1.15f );
			float wave = 0.5f + 0.5f * sin( uv.y * 28.0f - Time * 1.4f + sin( uv.x * 8.0f ) * 1.6f );

			// Subtle starlight shimmer in dark regions
			float star = pow( saturate( sin( uv.x * 91.3f + Time * 0.35f ) * cos( uv.y * 67.7f - Time * 0.25f ) ), 18.0f );

			c.rgb *= ( 0.94f + 0.14f * halo * breath );
			c.rgb += float3( 0.08f, 0.07f, 0.04f ) * halo * wave * 0.28f;
			c.rgb += float3( 0.35f, 0.30f, 0.18f ) * star * 0.45f * c.a;

			c *= Color;
			return c;
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
