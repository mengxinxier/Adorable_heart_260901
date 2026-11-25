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
			float radial = length( float2( d.x * 0.90f, d.y * 1.05f ) );
			float edge = smoothstep( 0.68f, 1.28f, radial );

			float2 uv1 = v.vTexCoord * float2( 1.80f, 1.10f ) + float2( Time * 0.015f, -Time * 0.009f );
			float2 uv2 = v.vTexCoord * float2( 3.10f, 1.75f ) + float2( -Time * 0.012f, Time * 0.013f );
			float4 s1 = tex2D( MapTexture, uv1 );
			float4 s2 = tex2D( MapTexture, uv2 );
			float mist = 0.55f * s1.r + 0.45f * s2.g;

			float breath = 0.65f + 0.35f * sin( Time * 0.85f );
			float3 fogCol = lerp( float3( 0.05f, 0.03f, 0.08f ), float3( 0.14f, 0.05f, 0.16f ), mist );
			float alpha = saturate( edge * ( 0.24f + 0.34f * mist ) * breath );

			return float4( fogCol, alpha ) * Color;
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
