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
			// Stationary quad so overlaid text/buttonText stays locked and razor-sharp
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
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
			float shimmer = 0.50f + 0.50f * sin( Time * 2.8f + ( v.vTexCoord.x + v.vTexCoord.y ) * 3.6f );
			float topSheen = 1.0f - smoothstep( 0.0f, 0.34f, v.vTexCoord.y );
			float3 lift = float3( 0.085f, 0.076f, 0.044f ) * shimmer + float3( 0.075f, 0.068f, 0.042f ) * topSheen;
			OutColor.rgb += lift * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			float topInset = 1.0f - smoothstep( 0.0f, 0.28f, v.vTexCoord.y );
			float botBounce = smoothstep( 0.78f, 1.0f, v.vTexCoord.y ) * 0.045f;
			float rimShade = 1.0f - saturate( topInset * 0.18f );
			OutColor.rgb = OutColor.rgb * 0.85f * rimShade + float3( botBounce, botBounce * 0.94f, botBounce * 0.84f ) * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDisable
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			float grey = dot( OutColor.rgb, float3( 0.299f, 0.587f, 0.114f ) );
			float3 coolGrey = float3( grey * 0.86f, grey * 0.87f, grey * 0.89f );
			OutColor.rgb = lerp( OutColor.rgb, coolGrey, 0.74f );
			OutColor.a *= 0.88f;
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

Effect Up      { VertexShader = "VertexShader"  PixelShader = "PixelShaderUp"      BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShader"  PixelShader = "PixelShaderDown"    BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShader"  PixelShader = "PixelShaderDisable" BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShader"  PixelShader = "PixelShaderOver"    BlendState = "BlendState" }
