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
			float2 uv1 = v.vTexCoord * float2( 1.15f, 0.85f )
			           + float2( Time * 0.028f + sin( Time * 0.55f ) * 0.018f, -Time * 0.045f );
			float2 uv2 = v.vTexCoord * float2( 1.75f, 1.35f )
			           + float2( -Time * 0.019f + cos( Time * 0.45f ) * 0.014f, -Time * 0.064f )
			           + float2( 0.41f, 0.27f );

			float4 s1 = tex2D( MapTexture, uv1 );
			float4 s2 = tex2D( MapTexture, uv2 );

			float a1 = s1.a;
			float a2 = s2.a * 0.68f;
			float totalA = saturate( a1 + a2 * ( 1.0f - a1 ) );
			float3 col = ( s1.rgb * a1 + s2.rgb * a2 * ( 1.0f - a1 ) ) / max( totalA, 0.001f );

			float twinkle = 0.82f + 0.28f * sin( Time * 2.6f + v.vTexCoord.x * 11.0f + v.vTexCoord.y * 7.0f );

			// Smooth feathered edges so particles never hard-clip at container edges
			float edgeMask = smoothstep( 0.0f, 0.14f, v.vTexCoord.x )
			               * ( 1.0f - smoothstep( 0.86f, 1.0f, v.vTexCoord.x ) )
			               * smoothstep( 0.0f, 0.14f, v.vTexCoord.y )
			               * ( 1.0f - smoothstep( 0.86f, 1.0f, v.vTexCoord.y ) );

			float4 OutColor = float4( col * twinkle, totalA * edgeMask * 0.85f ) * Color;
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

Effect Up      { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Down    { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Disable { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
Effect Over    { VertexShader = "VertexShader"  PixelShader = "PixelShader"  BlendState = "BlendState" }
