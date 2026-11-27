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
			float sec = t * 3.60f;

			float edgeLock = smoothstep( 0.02f, 0.07f, uv.x ) * ( 1.0f - smoothstep( 0.93f, 0.98f, uv.x ) )
			               * smoothstep( 0.02f, 0.06f, uv.y ) * ( 1.0f - smoothstep( 0.94f, 0.98f, uv.y ) );

			float f01 = pulseEnv( sec, 0.08f, 0.12f, 0.92f );
			float f02 = pulseEnv( sec, 0.24f, 0.12f, 0.96f );
			float f03 = pulseEnv( sec, 0.92f, 0.14f, 0.82f );
			float f04 = pulseEnv( sec, 1.28f, 0.13f, 0.88f );
			float f05 = pulseEnv( sec, 1.54f, 0.12f, 0.94f );
			float f06 = pulseEnv( sec, 1.74f, 0.11f, 0.98f );
			float f07 = pulseEnv( sec, 1.88f, 0.10f, 1.00f );
			float f08 = pulseEnv( sec, 2.00f, 0.09f, 1.00f );
			float f09 = pulseEnv( sec, 2.10f, 0.15f, 1.00f );
			float f10 = pulseEnv( sec, 2.92f, 0.14f, 0.96f );
			float winGate = 1.0f - smoothstep( 3.09f, 3.20f, sec );
			float gA = max( max( f01, f02 ), max( f03, f04 ) );
			float gB = max( max( f05, f06 ), max( f07, f08 ) );
			float strobe = saturate( max( max( gA, gB ), max( f09, f10 ) ) ) * winGate;

			float tick = floor( sec * 32.0f );
			float jRow = frac( sin( floor( uv.y * 24.0f ) * 157.3f + tick * 43.1f ) * 43758.5f ) * 2.0f - 1.0f;
			float jY = ( frac( sin( tick * 71.9f ) * 19341.7f ) * 2.0f - 1.0f ) * 0.0045f;
			float2 jLoc = clamp( uv + float2( jRow * 0.016f * strobe, jY * strobe ) * edgeLock, 0.002f, 0.998f );

			float ca = 0.0105f * strobe * edgeLock;
			float4 baseCol = tex2D( MapTexture, float2( frameOff + jLoc.x * 0.5f, jLoc.y ) );
			float2 rLoc = clamp( jLoc + float2( ca, -0.002f * strobe ), 0.002f, 0.998f );
			float2 bLoc = clamp( jLoc - float2( ca, 0.002f * strobe ), 0.002f, 0.998f );
			float rCh = tex2D( MapTexture, float2( frameOff + rLoc.x * 0.5f, rLoc.y ) ).r;
			float bCh = tex2D( MapTexture, float2( frameOff + bLoc.x * 0.5f, bLoc.y ) ).b;
			float3 col = float3( rCh, baseCol.g, bCh );

			float2 gLoc = clamp( jLoc + float2( 0.0145f, -0.004f ) * strobe, 0.002f, 0.998f );
			float3 ghostCol = tex2D( MapTexture, float2( frameOff + gLoc.x * 0.5f, gLoc.y ) ).rgb;
			col = lerp( col, ghostCol, 0.30f * strobe * edgeLock );

			float2 sRLoc = clamp( jLoc + float2( 0.0032f, 0.0f ), 0.002f, 0.998f );
			float2 sDLoc = clamp( jLoc + float2( 0.0f, 0.0045f ), 0.002f, 0.998f );
			float3 sR = tex2D( MapTexture, float2( frameOff + sRLoc.x * 0.5f, sRLoc.y ) ).rgb;
			float3 sD = tex2D( MapTexture, float2( frameOff + sDLoc.x * 0.5f, sDLoc.y ) ).rgb;
			float grad = saturate( ( length( baseCol.rgb - sR ) + length( baseCol.rgb - sD ) ) * 3.8f );

			float darkBreath = 0.5f + 0.5f * sin( Time * 0.45f );
			col *= lerp( 0.94f + 0.06f * darkBreath, 1.22f, strobe * edgeLock );
			col += float3( 0.46f, 0.41f, 0.64f ) * grad * strobe * edgeLock;

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
