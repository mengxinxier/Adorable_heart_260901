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
			// Pinned near top knot/bookmark crease; whole bow & pendant swing gently on hover
			float pendWeight = 0.28f + 0.72f * saturate( v.vTexCoord.y );
			pos.x += sin( Time * 8.6f ) * 2.8f * pendWeight;
			pos.y -= ( 0.5f + 0.5f * cos( Time * 8.6f ) ) * 1.15f * pendWeight;
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
			// Tactile downward tug on silk bow & charm
			pos.x += 0.6f;
			pos.y -= 2.4f;
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
			OutColor.rgb += float3( 0.085f, 0.062f, 0.058f ) * OutColor.a;
			OutColor *= Color;
			return OutColor;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 OutColor = tex2D( MapTexture, v.vTexCoord );
			OutColor.rgb *= float3( 0.90f, 0.86f, 0.87f );
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

Effect Up      { VertexShader = "VertexShaderUp"   PixelShader = "PixelShaderUp"      BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShaderDown" PixelShader = "PixelShaderDown"    BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShaderUp"   PixelShader = "PixelShaderDisable" BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShaderOver" PixelShader = "PixelShaderOver"    BlendState = "BlendState" }
