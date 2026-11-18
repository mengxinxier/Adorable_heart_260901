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
			// Locked quad vertices for multi-line dynamic easter-egg sticky notes
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
			float2 uv = v.vTexCoord;
			// Bounce only left plum wax seal inside 340x36 strip (x in 6..32, y in 5..31)
			float2 px = float2( uv.x * 340.0f - 19.0f, uv.y * 36.0f - 18.0f );
			float inSeal = 1.0f - smoothstep( 10.5f, 13.0f, length( px ) );
			float2 sealUv = float2( uv.x, clamp( uv.y + 1.4f / 36.0f, 0.14f, 0.86f ) );
			float4 OutColor = tex2D( MapTexture, lerp( uv, sealUv, inSeal ) );
			float shimmer = 0.55f + 0.45f * sin( Time * 2.4f + ( uv.x + uv.y ) * 3.2f );
			float topHighlight = 1.0f - smoothstep( 0.0f, 0.30f, uv.y );
			OutColor.rgb += ( float3( 0.075f, 0.058f, 0.060f ) * shimmer + float3( 0.055f, 0.045f, 0.032f ) * topHighlight ) * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float2 uv = v.vTexCoord;
			float2 px = float2( uv.x * 340.0f - 19.0f, uv.y * 36.0f - 18.0f );
			float inSeal = 1.0f - smoothstep( 10.5f, 13.0f, length( px ) );
			float2 sealUv = float2( uv.x, clamp( uv.y - 1.5f / 36.0f, 0.14f, 0.86f ) );
			float4 OutColor = tex2D( MapTexture, lerp( uv, sealUv, inSeal ) );
			float topInset = 1.0f - smoothstep( 0.0f, 0.28f, uv.y );
			OutColor.rgb *= float3( 0.88f, 0.84f, 0.85f ) * ( 1.0f - saturate( topInset * 0.16f ) );
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
			OutColor.rgb = lerp( OutColor.rgb, float3( grey, grey, grey ), 0.65f );
			OutColor *= Color;
			return OutColor;
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "src_alpha"
	DestBlend = "inv_src_alpha"
}

Effect Up      { VertexShader = "VertexShader" PixelShader = "PixelShaderUp"      BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShader" PixelShader = "PixelShaderDown"    BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShader" PixelShader = "PixelShaderDisable" BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShader" PixelShader = "PixelShaderOver"    BlendState = "BlendState" }
