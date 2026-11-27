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
			float2 d = ( uv - 0.5f ) * 2.0f;
			float edgeX = smoothstep( 0.60f, 1.02f, abs( d.x ) );
			float edgeY = smoothstep( 0.76f, 1.04f, abs( d.y ) );
			float outer = saturate( edgeX * 0.86f + edgeY * 0.66f );

			float2 uv1 = uv * float2( 1.732f, 1.118f ) + float2( Time * 0.010f, -Time * 0.006f );
			float2 uv2 = uv * float2( 3.141f, 2.236f ) + float2( -Time * 0.008f, Time * 0.009f );
			float2 uv3 = uv * float2( 5.385f, 3.605f ) + float2( Time * 0.005f, Time * 0.007f );

			float n1 = tex2D( MapTexture, uv1 ).b;
			float n2 = tex2D( MapTexture, uv2 ).g;
			float n3 = tex2D( MapTexture, uv3 ).r;
			float mist = 0.48f * n1 + 0.34f * n2 + 0.18f * n3;
			float silverDrift = smoothstep( 0.70f, 0.94f, n2 * 0.55f + n3 * 0.45f ) * outer;

			float hbCyc = fmod( Time, 2.40f );
			float hb1 = ( hbCyc - 0.24f ) * 7.5f;
			float hb2 = ( hbCyc - 0.56f ) * 9.5f;
			float beat1 = exp( -( hb1 * hb1 ) );
			float beat2 = exp( -( hb2 * hb2 ) ) * 0.55f;
			float heartBreath = 0.78f + 0.12f * sin( Time * 0.62f ) + 0.14f * saturate( beat1 + beat2 );

			float3 baseCol = lerp( float3( 0.016f, 0.018f, 0.030f ), float3( 0.072f, 0.050f, 0.112f ), mist );
			float3 driftTint = float3( 0.09f, 0.10f, 0.16f ) * silverDrift;

			float alpha = saturate( outer * ( 0.34f + 0.34f * mist ) * heartBreath );
			float3 col = saturate( baseCol + driftTint );

			return float4( col, alpha ) * Color;
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
