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

			// Damped seal-stamp scale: 1.36 -> 0.94 -> 1.08
			float punchScale = lerp( 1.36f, 0.94f, smoothstep( 0.0f, 0.18f, t ) );
			punchScale = lerp( punchScale, 1.08f, smoothstep( 0.18f, 0.92f, t ) );
			float2 scaledLocal = ( localUV - 0.5f ) / punchScale + 0.5f;

			float inside = step( 0.01f, scaledLocal.x ) * step( scaledLocal.x, 0.99f )
			             * step( 0.01f, scaledLocal.y ) * step( scaledLocal.y, 0.99f );
			float2 clampedLocal = clamp( scaledLocal, float2( 0.01f, 0.01f ), float2( 0.99f, 0.99f ) );
			float2 sampleUV = float2( frameOff + clampedLocal.x * 0.5f, clampedLocal.y );

			float4 c = tex2D( MapTexture, sampleUV ) * inside;

			// Vertical golden-jade light curtain sweeping top -> bottom across the portrait
			float sweepPos = lerp( -0.15f, 1.15f, smoothstep( 0.02f, 0.52f, t ) );
			float sweepBand = exp( -pow( ( localUV.y - sweepPos ) * 7.5f, 2.0f ) )
			                * ( 1.0f - smoothstep( 0.38f, 0.62f, t ) );
			float portraitBox = step( 0.14f, localUV.x ) * step( localUV.x, 0.86f )
			                  * step( 0.12f, localUV.y ) * step( localUV.y, 0.88f );
			float curtain = sweepBand * portraitBox;

			// Dual expanding golden & jade shockwave rings
			float2 aspectDelta = ( localUV - 0.5f ) * float2( 1.8f, 2.2f );
			float dist = length( aspectDelta );
			float ringPos1 = lerp( 0.18f, 1.05f, smoothstep( 0.04f, 0.65f, t ) );
			float ringPos2 = lerp( 0.10f, 0.88f, smoothstep( 0.14f, 0.78f, t ) );
			float d1 = ( dist - ringPos1 ) * 12.0f;
			float d2 = ( dist - ringPos2 ) * 15.0f;
			float ring1 = exp( -( d1 * d1 ) ) * ( 1.0f - smoothstep( 0.18f, 0.70f, t ) );
			float ring2 = exp( -( d2 * d2 ) ) * ( 1.0f - smoothstep( 0.28f, 0.84f, t ) );

			c.rgb = lerp( c.rgb, float3( 1.00f, 0.88f, 0.42f ), saturate( ring1 * 0.65f + curtain * 0.75f ) );
			c.rgb = lerp( c.rgb, float3( 0.48f, 0.94f, 0.82f ), ring2 * 0.48f );
			c.a = max( c.a, max( max( ring1 * 0.55f, ring2 * 0.40f ), curtain * 0.62f ) );

			// Smooth fade-in and guaranteed clean fade-out to zero at end of single shot
			float fadeIn = smoothstep( 0.0f, 0.05f, t );
			float fadeOut = 1.0f - smoothstep( 0.56f, 0.95f, t );
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
