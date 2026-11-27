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
			if ( t >= 0.95f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}
			float2 localUV = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float4 drv = tex2D( MapTexture, float2( frameOff + clamp( localUV.x, 0.002f, 0.998f ) * 0.5f, clamp( localUV.y, 0.002f, 0.998f ) ) );
			float2 centered = ( localUV - 0.5f ) * 2.0f;
			float radial = saturate( length( float2( centered.x * 0.88f, centered.y * 0.94f ) ) * 0.74f );
			float cloud = ( drv.r * 0.58f + drv.g * 0.42f ) - 0.5f;
			float wisp = smoothstep( 0.44f, 0.88f, drv.g * 0.64f + drv.r * 0.36f );

			float stage1Flash = 1.0f - smoothstep( 0.008f, 0.046f, t );
			float stage1Hold = 1.0f - smoothstep( 0.041f, 0.100f, t );
			float chargePulse = smoothstep( 0.040f, 0.074f, t ) * ( 1.0f - smoothstep( 0.094f, 0.150f, t ) );

			float u = smoothstep( 0.100f, 0.880f, t );
			float quint = u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
			float openCurve = 1.0f - pow( 1.0f - u, 2.45f );
			float waveFront = openCurve * 1.24f;
			float organicDist = radial + cloud * 0.24f;
			float curtainMask = smoothstep( waveFront - 0.26f, waveFront + 0.16f, organicDist );
			float tailZero = 1.0f - smoothstep( 0.86f, 0.95f, t );

			float veilAlpha = lerp( curtainMask * ( 1.0f - openCurve * 0.22f - quint * 0.02f ), 1.0f, stage1Hold );
			veilAlpha = saturate( max( veilAlpha, ( 1.0f - smoothstep( 0.086f, 0.106f, t ) ) * 0.985f ) ) * tailZero;

			float waveDelta = organicDist - waveFront;
			float waveBand = exp( -waveDelta * waveDelta * 16.0f );
			float waveEnv = smoothstep( 0.096f, 0.160f, t ) * ( 1.0f - smoothstep( 0.64f, 0.90f, t ) );
			float moonSurge = waveBand * waveEnv * ( 0.58f + 0.42f * drv.g );

			float centerCore = exp( -radial * radial * 5.2f );
			float3 deepObsidian = lerp( float3( 0.016f, 0.008f, 0.028f ), float3( 0.044f, 0.020f, 0.078f ), drv.g );
			float3 violetVelvet = float3( 0.135f, 0.072f, 0.225f ) * wisp * ( 0.35f + 0.65f * curtainMask );
			float3 impactCol = lerp( float3( 0.032f, 0.016f, 0.058f ), float3( 0.72f, 0.64f, 0.92f ), centerCore * ( 0.72f + 0.28f * drv.r ) );
			float3 chargeCol = lerp( float3( 0.38f, 0.26f, 0.64f ), float3( 0.86f, 0.74f, 0.48f ), 0.42f * drv.r ) * centerCore * ( 0.65f + 0.35f * drv.g );
			float goldMix = smoothstep( 0.32f, 0.78f, drv.r * 0.65f + drv.b * 0.35f );
			float3 moonWaveCol = lerp( float3( 0.64f, 0.52f, 0.88f ), float3( 0.90f, 0.78f, 0.50f ), goldMix * 0.55f );

			float3 col = saturate( deepObsidian + violetVelvet );
			col = lerp( col, impactCol, saturate( stage1Flash * 0.92f ) );
			col = saturate( col + chargeCol * chargePulse * 0.68f );
			col = lerp( col, moonWaveCol, saturate( moonSurge * 0.82f ) );
			float alpha = saturate( max( veilAlpha, moonSurge * 0.62f * tailZero ) );
			return float4( saturate( col ), alpha ) * Color;
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
