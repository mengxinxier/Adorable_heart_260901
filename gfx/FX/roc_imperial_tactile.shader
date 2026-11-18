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
	MainCode VertexShaderUp
	[[
		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			return Out;
		}
	]]

	MainCode VertexShaderOver
	[[
		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			float3 pos = v.vPosition.xyz;
			pos.y += 1.6f;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			return Out;
		}
	]]

	MainCode VertexShaderDown
	[[
		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			float3 pos = v.vPosition.xyz;
			pos.x += 0.8f;
			pos.y -= 2.0f;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShaderUp
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderOver
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			float shimmer = 0.55f + 0.45f * sin( Time * 2.8f + ( v.vTexCoord.x + v.vTexCoord.y ) * 3.5f );
			float topHighlight = 1.0f - smoothstep( 0.0f, 0.35f, v.vTexCoord.y );
			float3 goldTint = float3( 0.11f, 0.09f, 0.04f ) * shimmer + float3( 0.08f, 0.07f, 0.04f ) * topHighlight;
			OutColor.rgb += goldTint * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			OutColor.rgb *= 0.84f;
			OutColor *= Color;
			return OutColor;
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
}

Effect Up      { VertexShader = "VertexShaderUp"    PixelShader = "PixelShaderUp"    BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShaderDown"  PixelShader = "PixelShaderDown"  BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShaderUp"    PixelShader = "PixelShaderUp"    BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShaderOver"  PixelShader = "PixelShaderOver"  BlendState = "BlendState" }
