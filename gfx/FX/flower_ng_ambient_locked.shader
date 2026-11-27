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
			float pulse = 0.88f + 0.12f * sin( Time * 1.18f );
			float radial = length( float2( d.x * 0.90f, d.y * 1.06f ) ) * pulse;
			float outer = smoothstep( 0.58f, 1.18f, radial );

			float2 uv1 = uv * float2( 2.3f, 1.4f ) + float2( Time * 0.015f, -Time * 0.011f );
			float2 uv2 = uv * float2( 4.8f, 2.9f ) + float2( -Time * 0.018f, Time * 0.015f );
			float mist = 0.54f * tex2D( MapTexture, uv1 ).b + 0.46f * tex2D( MapTexture, uv2 ).g;

			// Aristocratic interwoven pale-gold & silver-violet silk threads along outer frame
			float2 tUv = float2( uv.x * 1.65f + uv.y * 1.25f, uv.y * 0.28f - uv.x * 0.16f );
			float tn = tex2D( MapTexture, tUv + float2( Time * 0.004f, -Time * 0.003f ) ).r;
			float thread = ( 1.0f - smoothstep( 0.002f, 0.013f, abs( tn - 0.50f ) ) ) * smoothstep( 0.74f, 1.24f, radial );
			float tPulse = pow( saturate( sin( Time * 0.85f ) * 0.5f + 0.5f ), 2.0f );

			// Gothic deep ink-violet & cold silver-violet twilight fog
			float3 darkEmerald = float3( 0.032f, 0.014f, 0.056f );
			float3 silverViolet = float3( 0.075f, 0.058f, 0.128f );
			float3 darkFog = lerp( darkEmerald, silverViolet, mist );

			float goldMix = 0.5f + 0.5f * sin( uv.y * 9.0f + Time * 0.6f );
			float3 threadCol = lerp( float3( 0.62f, 0.56f, 0.78f ), float3( 0.74f, 0.65f, 0.44f ), goldMix );

			float alpha = saturate( outer * ( 0.50f + 0.34f * mist ) + thread * 0.38f * tPulse );
			float3 col = lerp( darkFog, threadCol, saturate( ( thread * 0.78f * tPulse ) / max( alpha, 0.001f ) ) );

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
