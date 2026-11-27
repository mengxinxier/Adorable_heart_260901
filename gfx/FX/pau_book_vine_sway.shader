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
			float3 pos = v.vPosition.xyz;
			// Gentle breeze sway stronger on free blossom cluster edges
			float edgeWave = saturate( 1.0f - v.vTexCoord.y * 0.65f );
			pos.x += sin( Time * 1.15f + v.vTexCoord.y * 4.5f ) * 1.8f * edgeWave;
			pos.y += cos( Time * 0.90f + v.vTexCoord.x * 3.8f ) * 0.7f * edgeWave;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1.0f ) );
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
			float petalGlow = smoothstep( 0.08f, 0.32f, c.r - c.b );
			float breath = 0.5f + 0.5f * sin( Time * 1.65f + v.vTexCoord.x * 3.0f );
			c.rgb += float3( 0.055f, 0.022f, 0.028f ) * petalGlow * breath * c.a;
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
