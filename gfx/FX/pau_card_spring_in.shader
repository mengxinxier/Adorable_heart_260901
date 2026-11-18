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
	float  vProgress : TEXCOORD1;
};

VertexShader =
{
	MainCode VertexShader
	[[
		static const float NO_OF_FRAMES = 2.0f;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			// Single-shot damped card slide-in on tab/character container reveal
			float t = ( Offset.x + AnimationTime / NO_OF_FRAMES )
			        * ( NO_OF_FRAMES / ( NO_OF_FRAMES - 1.0f ) );
			t = saturate( t );

			// Smooth paper-sheen wave on reveal without shifting rectangles out from under card text
			float3 pos = v.vPosition.xyz;

			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			Out.vProgress = t;
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
			float4 c = tex2D( MapTexture, v.vTexCoord );
			float t = v.vProgress;
			// Soft sunlit diagonal sweep across cardstock on reveal, then fade to transparent
			float sheen = smoothstep( 0.0f, 0.45f, 1.0f - abs( ( v.vTexCoord.x * 0.55f + v.vTexCoord.y * 0.25f ) - t * 1.15f ) );
			float alphaEnv = smoothstep( 0.0f, 0.12f, t ) * ( 1.0f - smoothstep( 0.45f, 0.96f, t ) );
			c.a *= alphaEnv * ( 0.48f + 0.38f * sheen );
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
