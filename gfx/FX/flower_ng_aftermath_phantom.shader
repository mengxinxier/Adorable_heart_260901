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
	float4 vAnimData : TEXCOORD1;
};

VertexShader =
{
	MainCode VertexShader
	[[
		static const float NO_OF_FRAMES = 2.0f;

		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			float t = saturate( ( Offset.x + AnimationTime / NO_OF_FRAMES ) * ( NO_OF_FRAMES / ( NO_OF_FRAMES - 1.0f ) ) );
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
			Out.vTexCoord = v.vTexCoord + Offset;
			Out.vAnimData = float4( v.vTexCoord.x * NO_OF_FRAMES, v.vTexCoord.y, t, Offset.x );
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
			float t = v.vAnimData.z;
			if ( t >= 0.94f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}
			float env0 = smoothstep( 0.018f, 0.029f, t ) * ( 1.0f - smoothstep( 0.040f, 0.060f, t ) ) * 0.54f;
			float env1 = smoothstep( 0.170f, 0.215f, t ) * ( 1.0f - smoothstep( 0.250f, 0.300f, t ) ) * 0.34f;
			float env2 = smoothstep( 0.440f, 0.505f, t ) * ( 1.0f - smoothstep( 0.550f, 0.610f, t ) ) * 0.46f;
			float env = max( env0, max( env1, env2 ) );
			if ( env <= 0.001f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}
			float2 uv = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float2 baseUV = uv + float2( 0.0020f * sin( Time * 0.52f ), 0.0028f * cos( Time * 0.41f ) );

			float twitch0 = exp( -pow( ( t - 0.034f ) / 0.0065f, 2.0f ) );
			float twitch1 = exp( -pow( ( t - 0.232f ) / 0.0025f, 2.0f ) );
			float twitch2 = exp( -pow( ( t - 0.528f ) / 0.0025f, 2.0f ) );
			float twitch = max( twitch0 * 0.85f, max( twitch1, twitch2 ) );
			float dx = 0.0035f + 0.0105f * twitch;

			float4 cMain = tex2D( MapTexture, float2( frameOff + clamp( baseUV.x, 0.002f, 0.998f ) * 0.5f, clamp( baseUV.y, 0.002f, 0.998f ) ) );
			float4 cPos = tex2D( MapTexture, float2( frameOff + clamp( baseUV.x + dx, 0.002f, 0.998f ) * 0.5f, clamp( baseUV.y, 0.002f, 0.998f ) ) );
			float4 cNeg = tex2D( MapTexture, float2( frameOff + clamp( baseUV.x - dx, 0.002f, 0.998f ) * 0.5f, clamp( baseUV.y, 0.002f, 0.998f ) ) );

			float ghostW = 0.24f + 0.24f * twitch;
			float combA = saturate( cMain.a * 0.88f + ( cPos.a + cNeg.a ) * ( 0.5f * ghostW ) );
			if ( combA <= 0.002f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}
			float3 col = ( cMain.rgb * cMain.a * 0.88f + cPos.rgb * float3( 0.78f, 0.88f, 1.18f ) * cPos.a * ( 0.5f * ghostW ) + cNeg.rgb * float3( 0.92f, 0.62f, 1.16f ) * cNeg.a * ( 0.5f * ghostW ) ) / max( combA, 0.001f );
			float luma = dot( col, float3( 0.299f, 0.587f, 0.114f ) );
			float violetPop = saturate( ( col.b - col.g ) * 2.4f + ( col.r - col.g ) * 0.9f );
			float hlGlow = smoothstep( 0.45f, 0.90f, luma ) * 0.18f + violetPop * 0.26f;
			col = saturate( lerp( float3( 0.048f, 0.024f, 0.092f ), col, 0.92f ) + float3( 0.10f, 0.06f, 0.22f ) * hlGlow );
			float alpha = saturate( combA * env * ( 0.94f + 0.06f * sin( Time * 1.15f ) ) * ( 0.96f + 0.12f * hlGlow ) );
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
