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
	float4 vBurstData : TEXCOORD1;
};

VertexShader =
{
	MainCode VertexShader
	[[
		static const float NO_OF_FRAMES = 2.0f;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			// Single-shot progress driven by frameAnimatedSpriteType + play_on_show = yes
			float t = ( Offset.x + AnimationTime / NO_OF_FRAMES )
			        * ( NO_OF_FRAMES / ( NO_OF_FRAMES - 1.0f ) );
			t = saturate( t );

			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			Out.vBurstData = float4( v.vTexCoord.x * NO_OF_FRAMES, v.vTexCoord.y, t, Offset.x );
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
			float t = v.vBurstData.z;
			float2 localUV = v.vBurstData.xy;
			float frameOff = v.vBurstData.w;

			// Impact punch: 1.32 -> 0.90 -> 1.18 expansion
			float punchScale = lerp( 1.32f, 0.90f, smoothstep( 0.0f, 0.14f, t ) );
			punchScale = lerp( punchScale, 1.18f, smoothstep( 0.14f, 0.96f, t ) );
			float2 scaledLocal = ( localUV - 0.5f ) / punchScale + 0.5f;

			float inside = step( 0.01f, scaledLocal.x ) * step( scaledLocal.x, 0.99f )
			             * step( 0.01f, scaledLocal.y ) * step( scaledLocal.y, 0.99f );
			float2 clampedLocal = clamp( scaledLocal, float2( 0.01f, 0.01f ), float2( 0.99f, 0.99f ) );
			float2 sampleUV = float2( frameOff + clampedLocal.x * 0.5f, clampedLocal.y );

			float4 c = tex2D( MapTexture, sampleUV ) * inside;

			// Dual expanding imperial gold & azure-crimson shock rings
			float dist = length( localUV - 0.5f ) * 2.0f;
			float ringPos1 = lerp( 0.14f, 0.92f, smoothstep( 0.02f, 0.55f, t ) );
			float ringPos2 = lerp( 0.08f, 0.78f, smoothstep( 0.10f, 0.68f, t ) );
			float d1 = ( dist - ringPos1 ) * 13.0f;
			float d2 = ( dist - ringPos2 ) * 16.0f;
			float ring1 = exp( -( d1 * d1 ) ) * ( 1.0f - smoothstep( 0.12f, 0.62f, t ) );
			float ring2 = exp( -( d2 * d2 ) ) * ( 1.0f - smoothstep( 0.22f, 0.78f, t ) );

			c.rgb = lerp( c.rgb, float3( 0.98f, 0.82f, 0.34f ), ring1 * 0.55f );
			c.rgb = lerp( c.rgb, float3( 0.42f, 0.78f, 0.98f ), ring2 * 0.40f );
			c.a = max( c.a, max( ring1 * 0.46f, ring2 * 0.32f ) );

			// Fade-in & guaranteed clean fade-out to zero even while paused
			float fadeIn = smoothstep( 0.0f, 0.05f, t );
			float fadeOut = 1.0f - smoothstep( 0.48f, 0.94f, t );
			c.a *= fadeIn * fadeOut;
			c *= Color;
			return c;
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
