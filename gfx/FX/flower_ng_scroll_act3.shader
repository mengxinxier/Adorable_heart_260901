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
			float sec = t * 3.25f;

			float edgeLock = smoothstep( 0.02f, 0.07f, uv.x ) * ( 1.0f - smoothstep( 0.93f, 0.98f, uv.x ) )
			               * smoothstep( 0.02f, 0.06f, uv.y ) * ( 1.0f - smoothstep( 0.94f, 0.98f, uv.y ) );

			float b1 = pulseEnv( sec, 0.10f, 0.16f, 0.90f );
			float b2 = pulseEnv( sec, 0.96f, 0.14f, 0.80f );
			float b3 = pulseEnv( sec, 1.58f, 0.13f, 0.88f );
			float b4 = pulseEnv( sec, 2.02f, 0.12f, 0.94f );
			float b5 = pulseEnv( sec, 2.32f, 0.11f, 0.98f );
			float b6 = pulseEnv( sec, 2.52f, 0.10f, 1.00f );
			float b7 = pulseEnv( sec, 2.68f, 0.18f, 1.00f );
			float winGate = 1.0f - smoothstep( 2.86f, 2.96f, sec );
			float burst = saturate( max( max( max( b1, b2 ), max( b3, b4 ) ), max( max( b5, b6 ), b7 ) ) ) * winGate;
			float accelGain = 0.86f + 0.28f * smoothstep( 0.85f, 2.70f, sec );
			float flashPulse = smoothstep( 0.40f, 0.94f, burst );

			float stepTick = floor( sec * 26.0f );
			float coarseRow = floor( uv.y * 16.0f );
			float fineRow = floor( uv.y * 54.0f );
			float hCoarse = frac( sin( coarseRow * 127.1f + stepTick * 31.7f ) * 43758.5f ) * 2.0f - 1.0f;
			float hFine = frac( sin( fineRow * 269.5f + stepTick * 19.3f ) * 19341.2f ) * 2.0f - 1.0f;
			float coarseGate = step( 0.25f, abs( hCoarse ) );

			float textCalm = lerp( 1.0f, 0.36f, smoothstep( 0.36f, 0.86f, uv.x ) );
			float shiftX = ( hCoarse * coarseGate * 0.024f + hFine * 0.0090f ) * burst * accelGain * textCalm * edgeLock;
			float2 tearLoc = clamp( uv + float2( shiftX, 0.0f ), 0.002f, 0.998f );

			float ca = 0.0115f * burst * accelGain * textCalm * edgeLock;
			float4 baseCol = tex2D( MapTexture, float2( frameOff + tearLoc.x * 0.5f, tearLoc.y ) );
			float2 rLoc = clamp( tearLoc + float2( ca, 0.0016f * burst ), 0.002f, 0.998f );
			float2 bLoc = clamp( tearLoc - float2( ca, 0.0016f * burst ), 0.002f, 0.998f );
			float rCh = tex2D( MapTexture, float2( frameOff + rLoc.x * 0.5f, rLoc.y ) ).r;
			float bCh = tex2D( MapTexture, float2( frameOff + bLoc.x * 0.5f, bLoc.y ) ).b;
			float3 col = float3( rCh, baseCol.g, bCh );

			float3 invCol = 1.0f - col;
			col = lerp( col, float3( invCol.r * 0.72f, invCol.g * 0.80f, invCol.b * 0.96f ), 0.18f * flashPulse * textCalm * edgeLock );
			col = ( col - 0.5f ) * ( 1.0f + 0.30f * flashPulse * edgeLock ) + 0.5f;
			col += float3( -0.04f, 0.02f, 0.11f ) * flashPulse * edgeLock;

			float portBreath = 0.5f + 0.5f * sin( Time * 0.55f + uv.y * 1.8f );
			float leftPort = ( 1.0f - smoothstep( 0.30f, 0.62f, uv.x ) ) * edgeLock;
			float goldThread = smoothstep( 0.40f, 0.76f, baseCol.r * 0.65f + baseCol.g * 0.35f ) * smoothstep( 0.04f, 0.22f, baseCol.r - baseCol.b );
			col += float3( 0.18f, 0.14f, 0.06f ) * goldThread * leftPort * ( 0.14f + 0.10f * portBreath + 0.78f * burst );

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
