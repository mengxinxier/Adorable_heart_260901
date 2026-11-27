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
			float2 uv = v.vTexCoord;

			// Dual-layer parallax gentle diagonal windblown rose-petal & moon-dust drift
			float2 uv1 = uv * float2( 1.85f, 1.12f )
			           + float2( Time * 0.026f + sin( Time * 0.52f + uv.y * 2.4f ) * 0.022f, -Time * 0.044f );
			float2 uv2 = uv * float2( 2.65f, 1.62f )
			           + float2( Time * 0.016f - cos( Time * 0.41f + uv.x * 2.0f ) * 0.016f, -Time * 0.031f )
			           + float2( 0.37f, 0.61f );

			float4 p1 = tex2D( MapTexture, uv1 );
			float4 p2 = tex2D( MapTexture, uv2 );

			float a1 = p1.a;
			float a2 = p2.a * 0.68f;
			float totalA = saturate( a1 + a2 * ( 1.0f - a1 ) );
			float3 col = ( p1.rgb * a1 + p2.rgb * a2 * ( 1.0f - a1 ) ) / max( totalA, 0.001f );

			// Strictly protect central portrait face & bottom iron-bolt button text area
			float dCenter = length( ( uv - float2( 0.55f, 0.50f ) ) / float2( 0.28f, 0.38f ) );
			float centerGuard = smoothstep( 0.68f, 1.14f, dCenter );
			float dBtn = length( ( uv - float2( 0.50f, 0.90f ) ) / float2( 0.24f, 0.12f ) );
			float btnGuard = smoothstep( 0.60f, 1.08f, dBtn );

			float edgeFeather = smoothstep( 0.0f, 0.06f, uv.x ) * ( 1.0f - smoothstep( 0.94f, 1.0f, uv.x ) )
			                  * smoothstep( 0.0f, 0.06f, uv.y ) * ( 1.0f - smoothstep( 0.94f, 1.0f, uv.y ) );

			float finalA = totalA * min( centerGuard, btnGuard ) * edgeFeather * 0.88f;
			return float4( col, finalA ) * Color;
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
