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
			// Local UI +y is upward: crisp hover lift
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
			// Tactile press depression
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
			float shimmer = 0.55f + 0.45f * sin( Time * 2.6f + ( v.vTexCoord.x + v.vTexCoord.y ) * 3.2f );
			float topHighlight = 1.0f - smoothstep( 0.0f, 0.32f, v.vTexCoord.y );
			float3 goldTint = float3( 0.095f, 0.082f, 0.042f ) * shimmer + float3( 0.070f, 0.062f, 0.036f ) * topHighlight;
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
			float topInset = 1.0f - smoothstep( 0.0f, 0.28f, v.vTexCoord.y );
			float botBounce = smoothstep( 0.78f, 1.0f, v.vTexCoord.y ) * 0.04f;
			float rimShade = 1.0f - saturate( topInset * 0.16f );
			OutColor.rgb = OutColor.rgb * 0.86f * rimShade + float3( botBounce, botBounce * 0.95f, botBounce * 0.85f ) * OutColor.a;
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

Effect Up      { VertexShader = "VertexShaderUp"    PixelShader = "PixelShaderUp"      BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShaderDown"  PixelShader = "PixelShaderDown"    BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShaderUp"    PixelShader = "PixelShaderDisable" BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShaderOver"  PixelShader = "PixelShaderOver"    BlendState = "BlendState" }
