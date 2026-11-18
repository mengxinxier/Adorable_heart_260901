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
			float env = smoothstep( 0.66f, 1.30f, dist );

			float2 uv1 = v.vTexCoord * float2( 1.95f, 1.15f ) + float2( Time * 0.022f, -Time * 0.012f );
			float2 uv2 = v.vTexCoord * float2( 3.40f, 1.95f ) + float2( -Time * 0.018f, Time * 0.016f );
			float4 s1 = tex2D( MapTexture, uv1 );
			float4 s2 = tex2D( MapTexture, uv2 );
			float mist = 0.56f * s1.r + 0.44f * s2.g;
			float mistSoft = mist * mist * 0.45f + mist * 0.55f;

			// Occasional creeping crimson thread veins along outer edge corners
			float2 uvt = float2( v.vTexCoord.x * 1.4f + v.vTexCoord.y * 1.6f, v.vTexCoord.y * 0.22f - v.vTexCoord.x * 0.12f );
			float4 st = tex2D( MapTexture, uvt + float2( Time * 0.004f, -Time * 0.003f ) );
			float threadDist = abs( st.r - 0.50f );
			float vein = ( 1.0f - smoothstep( 0.0015f, 0.014f, threadDist ) ) * smoothstep( 0.84f, 1.32f, dist );
			float pulseBase = saturate( sin( Time * 0.55f ) * 0.5f + 0.5f ) * saturate( sin( Time * 0.23f + 1.2f ) );
			float pulse = pow( max( pulseBase, 0.0001f ), 4.0f );

			float3 mistCol = lerp( float3( 0.16f, 0.26f, 0.33f ), float3( 0.30f, 0.48f, 0.54f ), mistSoft );
			float3 redCol = float3( 0.78f, 0.14f, 0.19f );
			float alpha = saturate( env * ( 0.28f + 0.50f * mistSoft ) + vein * 0.34f * pulse );
			float wRed = saturate( ( vein * 0.92f * pulse ) / max( alpha, 0.001f ) );
			float3 col = lerp( mistCol, redCol, wRed );
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
