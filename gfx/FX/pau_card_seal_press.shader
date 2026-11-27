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
			// Card border & live [?day] status stay pixel-locked while left Baiye medallion seal pops
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
			// Round medallion center sits at (29, 30) in 214x60 card with radius 23px
			float2 rel = float2( uv.x * 214.0f - 29.0f, uv.y * 60.0f - 30.0f );
			float inCircle = 1.0f - smoothstep( 22.0f, 24.5f, length( rel ) );
			float2 liftUv = float2( uv.x, clamp( uv.y + 2.0f / 60.0f, 0.10f, 0.90f ) );
			float4 OutColor = tex2D( MapTexture, lerp( uv, liftUv, inCircle ) );
			float shimmer = 0.55f + 0.45f * sin( Time * 2.4f + ( uv.x + uv.y ) * 3.2f );
			float topHighlight = 1.0f - smoothstep( 0.0f, 0.28f, uv.y );
			OutColor.rgb += ( float3( 0.075f, 0.058f, 0.060f ) * shimmer + float3( 0.065f, 0.052f, 0.038f ) * topHighlight + float3( 0.05f, 0.04f, 0.03f ) * inCircle ) * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float2 uv = v.vTexCoord;
			float2 rel = float2( uv.x * 214.0f - 29.0f, uv.y * 60.0f - 30.0f );
			float inCircle = 1.0f - smoothstep( 22.0f, 24.5f, length( rel ) );
			float2 downUv = float2( uv.x, clamp( uv.y - 2.0f / 60.0f, 0.10f, 0.90f ) );
			float4 OutColor = tex2D( MapTexture, lerp( uv, downUv, inCircle ) );
			float topInset = 1.0f - smoothstep( 0.0f, 0.26f, uv.y );
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
			OutColor.rgb = lerp( OutColor.rgb, float3( grey * 0.90f, grey * 0.86f, grey * 0.84f ), 0.70f );
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
