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
			float2 d = ( v.vTexCoord - 0.5f ) * 2.0f;
			float radial = length( float2( d.x * 0.938f, d.y * 1.02f ) );
			float boxEdge = max( abs( d.x ) * 0.92f, abs( d.y ) * 0.98f );
			float dist = 0.58f * radial + 0.42f * boxEdge;
			float outerEnv = smoothstep( 0.78f, 1.36f, dist );

			float2 uv1 = v.vTexCoord * float2( 1.75f, 1.00f ) + float2( Time * 0.018f, -Time * 0.009f );
			float2 uv2 = v.vTexCoord * float2( 2.90f, 1.65f ) + float2( -Time * 0.013f, Time * 0.014f );
			float4 s1 = tex2D( MapTexture, uv1 );
			float4 s2 = tex2D( MapTexture, uv2 );
			float mist = 0.58f * s1.r + 0.42f * s2.g;
			float glowCloud = smoothstep( 0.34f, 0.76f, mist );
			float warmShimmer = 0.90f + 0.10f * sin( Time * 1.35f );

			float3 colMist = float3( 0.36f, 0.52f, 0.57f );
			float3 colAmber = float3( 0.98f, 0.78f, 0.50f );
			float warmWeight = glowCloud * smoothstep( 0.70f, 1.16f, dist );
			float3 col = lerp( colMist, colAmber, warmWeight );
			float alpha = saturate( outerEnv * ( 0.12f + 0.40f * glowCloud ) * warmShimmer );
			float4 OutColor = float4( col, alpha ) * Color;
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
