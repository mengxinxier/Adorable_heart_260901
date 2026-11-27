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
			MipFilter = "Linear"
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
			float2 centered = v.vTexCoord - 0.5f;
			float r = length( centered );
			if ( r > 0.492f )
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );

			float angle = -Time * 0.38f;
			float c = cos( angle );
			float s = sin( angle );
			float2 ruv = float2( centered.x * c - centered.y * s, centered.x * s + centered.y * c ) + 0.5f;
			float4 tex = tex2D( MapTexture, ruv );

			// Radiant White-Sun breathing halo along tips
			float breathe = 0.90f + 0.20f * sin( Time * 2.4f - r * 14.0f );
			float2 dir = centered / max( r, 0.001f );
			float2 lightDir = float2( cos( Time * 0.95f ), sin( Time * 0.95f ) );
			float sweep = pow( saturate( dot( dir, lightDir ) ), 10.0f );
			tex.rgb = tex.rgb * breathe + float3( 0.22f, 0.28f, 0.36f ) * sweep * tex.a;

			tex *= Color;
			return tex;
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
