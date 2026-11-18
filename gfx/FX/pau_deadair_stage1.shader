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
			float env = smoothstep( 0.72f, 1.34f, dist );

			float2 uv1 = v.vTexCoord * float2( 1.85f, 1.05f ) + float2( Time * 0.015f, -Time * 0.008f );
			float2 uv2 = v.vTexCoord * float2( 3.10f, 1.75f ) + float2( -Time * 0.011f, Time * 0.013f );
			float4 s1 = tex2D( MapTexture, uv1 );
			float4 s2 = tex2D( MapTexture, uv2 );
			float mist = 0.58f * s1.r + 0.42f * s2.g;
			float mistSoft = mist * mist * 0.45f + mist * 0.55f;
			float breath = 0.92f + 0.08f * sin( Time * 0.85f );

			float3 col = lerp( float3( 0.24f, 0.38f, 0.44f ), float3( 0.42f, 0.62f, 0.68f ), mistSoft );
			float alpha = saturate( env * ( 0.18f + 0.44f * mistSoft ) * breath );
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
