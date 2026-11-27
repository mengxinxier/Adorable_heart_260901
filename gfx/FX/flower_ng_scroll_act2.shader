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
		float pulseEnv( float sec, float center, float width, float amp )
		{
			float wUp = width * 0.28f;
			float wDn = width * 0.72f;
			return smoothstep( center - wUp, center - wUp * 0.12f, sec )
			     * ( 1.0f - smoothstep( center + wDn * 0.18f, center + wDn, sec ) ) * amp;
		}

		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float2 uv = v.vAnimData.xy;
			float t = v.vAnimData.z;
			float frameOff = v.vAnimData.w;
			float sec = t * 2.90f;

			float edgeLock = smoothstep( 0.05f, 0.13f, uv.x ) * ( 1.0f - smoothstep( 0.87f, 0.95f, uv.x ) )
			               * smoothstep( 0.02f, 0.06f, uv.y ) * ( 1.0f - smoothstep( 0.94f, 0.98f, uv.y ) );

			float p1 = pulseEnv( sec, 0.98f, 0.12f, 0.72f );
			float p2 = pulseEnv( sec, 1.76f, 0.11f, 0.95f );
			float p3 = pulseEnv( sec, 1.98f, 0.22f, 1.00f );
			float winGate = 1.0f - smoothstep( 2.24f, 2.35f, sec );
			float glitch = saturate( max( p1, max( p2, p3 ) ) ) * winGate;

			float dPhoto = length( ( uv - float2( 0.73f, 0.39f ) ) / float2( 0.28f, 0.34f ) );
			float photoAura = ( 1.0f - smoothstep( 0.42f, 1.08f, dPhoto ) ) * edgeLock;

			float stepTick = floor( sec * 22.0f );
			float rowHash = frac( sin( floor( uv.y * 30.0f ) * 91.7f + stepTick * 17.3f ) * 43758.5f ) * 2.0f - 1.0f;
			float2 locUV = clamp( uv + float2( rowHash * 0.0110f * glitch * photoAura, 0.0f ), 0.002f, 0.998f );
			float4 baseCol = tex2D( MapTexture, float2( frameOff + locUV.x * 0.5f, locUV.y ) );

			float2 ghostLoc = clamp( locUV + float2( -0.0155f, 0.0035f ) * glitch, 0.002f, 0.998f );
			float3 ghostCol = tex2D( MapTexture, float2( frameOff + ghostLoc.x * 0.5f, ghostLoc.y ) ).rgb;
			float3 col = lerp( baseCol.rgb, ghostCol, 0.52f * glitch * photoAura );

			float dampBreath = 0.5f + 0.5f * sin( Time * 0.62f - uv.y * 2.4f + uv.x * 1.3f );
			float luma = dot( col, float3( 0.299f, 0.587f, 0.114f ) );
			float3 coldSilver = float3( luma * 0.86f, luma * 0.96f, luma * 1.08f );
			col = lerp( col, coldSilver, ( 0.05f + 0.05f * dampBreath ) * edgeLock + 0.30f * glitch * photoAura );
			col *= 1.0f - ( 0.025f * dampBreath * edgeLock + 0.09f * glitch * edgeLock + 0.13f * glitch * photoAura );
			col += float3( 0.09f, 0.10f, 0.14f ) * glitch * photoAura;

			return float4( saturate( col ), baseCol.a ) * Color;
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
