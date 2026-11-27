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
			// Dual-layer diagonal top-right to bottom-left windblown plum petal drift
			float2 uv1 = v.vTexCoord * float2( 1.05f, 0.95f )
			           + float2( Time * 0.042f + sin( Time * 0.65f ) * 0.025f, -Time * 0.068f );
			float2 uv2 = v.vTexCoord * float2( 1.55f, 1.45f )
			           + float2( Time * 0.024f - cos( Time * 0.50f ) * 0.018f, -Time * 0.048f )
			           + float2( 0.37f, 0.61f );

			float4 p1 = tex2D( MapTexture, uv1 );
			float4 p2 = tex2D( MapTexture, uv2 );

			float alpha1 = p1.a;
			float alpha2 = p2.a * 0.72f;
			float totalA = saturate( alpha1 + alpha2 * ( 1.0f - alpha1 ) );
			float3 col = ( p1.rgb * alpha1 + p2.rgb * alpha2 * ( 1.0f - alpha1 ) ) / max( totalA, 0.001f );

			// Feather quad edges so falling petals fade smoothly across window boundaries
			float edgeMask = smoothstep( 0.0f, 0.16f, v.vTexCoord.x )
			               * ( 1.0f - smoothstep( 0.84f, 1.0f, v.vTexCoord.x ) )
			               * smoothstep( 0.0f, 0.16f, v.vTexCoord.y )
			               * ( 1.0f - smoothstep( 0.84f, 1.0f, v.vTexCoord.y ) );

			float4 OutColor = float4( col, totalA * edgeMask * 0.86f ) * Color;
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
