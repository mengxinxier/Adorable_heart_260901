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
			AddressU = "Wrap"
			AddressV = "Wrap"
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
			Out.vTexCoord = v.vTexCoord;
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
			// 45-degree slanted dual-layer fullscreen rain (resolution-independent)
			float2 uv = v.vTexCoord;
			float c = 0.7071f;
			float2 rotUv = float2( uv.x * c + uv.y * c, -uv.x * c + uv.y * c );

			float2 uvNear = rotUv * float2( 1.25f, 1.15f ) + float2( 0.0f, -Time * 1.15f );
			float2 uvFar  = rotUv * float2( 2.10f, 1.85f ) + float2( 0.37f, -Time * 0.78f );

			float4 r1 = tex2D( MapTexture, uvNear );
			float4 r2 = tex2D( MapTexture, uvFar );

			float3 col = r1.rgb * 0.65f + r2.rgb * 0.35f;
			float alpha = saturate( r1.a * 0.72f + r2.a * 0.42f );
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
