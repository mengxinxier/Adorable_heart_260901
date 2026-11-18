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

			// Impact punch: 1.28 -> 0.94 -> 1.00 during early hit, then expand slightly outward
			float punchScale = lerp( 1.28f, 0.94f, smoothstep( 0.0f, 0.14f, t ) );
			punchScale = lerp( punchScale, 1.12f, smoothstep( 0.14f, 0.95f, t ) );
			float2 scaledLocal = ( localUV - 0.5f ) / punchScale + 0.5f;

			// Guard UV strictly inside active frame half so neighbor frame never bleeds
			float inside = step( 0.01f, scaledLocal.x ) * step( scaledLocal.x, 0.99f )
			             * step( 0.01f, scaledLocal.y ) * step( scaledLocal.y, 0.99f );
			float2 clampedLocal = clamp( scaledLocal, float2( 0.01f, 0.01f ), float2( 0.99f, 0.99f ) );
			float2 sampleUV = float2( frameOff + clampedLocal.x * 0.5f, clampedLocal.y );

			float4 c = tex2D( MapTexture, sampleUV ) * inside;

			// Subtle expanding crimson plum shock-ring on seal strike
			float dist = length( localUV - 0.5f ) * 2.0f;
			float ringPos = lerp( 0.16f, 0.88f, smoothstep( 0.04f, 0.52f, t ) );
			float ringDelta = ( dist - ringPos ) * 12.0f;
			float ring = exp( -( ringDelta * ringDelta ) )
			           * ( 1.0f - smoothstep( 0.10f, 0.58f, t ) );
			c.rgb = lerp( c.rgb, float3( 0.88f, 0.24f, 0.34f ), ring * 0.38f );
			c.a = max( c.a, ring * 0.26f );

			// Crisp fade-in and guaranteed clean fade-out to zero even while game is paused
			float fadeIn = smoothstep( 0.0f, 0.06f, t );
			float fadeOut = 1.0f - smoothstep( 0.52f, 0.94f, t );
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
