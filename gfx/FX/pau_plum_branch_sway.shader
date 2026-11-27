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
};

VertexShader =
{
	MainCode VertexShader
	[[
		// Must match noOfFrames = 5 on plum branch strip sprites
		static const float NO_OF_FRAMES = 5.0f;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			float3 pos = v.vPosition.xyz;
			// Anchor trunk base at bottom (vTexCoord.y == 1.0f); free upper blossoms sway softly
			float tipWeight = saturate( 1.0f - v.vTexCoord.y );
			tipWeight = tipWeight * tipWeight;
			float swayX = sin( Time * 1.45f ) * 1.85f * tipWeight;
			float swayY = cos( Time * 1.15f ) * 0.55f * tipWeight;
			pos.x += swayX;
			pos.y += swayY;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( pos, 1.0f ) );
			// Preserve frame strip Offset.x for manual frame = 1..5 switching
			Out.vTexCoord = v.vTexCoord + Offset;
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
			// Gentle living warmth pulse on crimson plum petals
			float petalMask = smoothstep( 0.08f, 0.34f, c.r - c.b );
			float breath = 0.5f + 0.5f * sin( Time * 1.85f );
			c.rgb += float3( 0.045f, 0.018f, 0.022f ) * petalMask * breath * c.a;
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
