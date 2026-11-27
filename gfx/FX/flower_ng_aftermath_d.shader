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

			float fadeIn = smoothstep( 0.005f, 0.028f, t );
			float uOut = saturate( ( t - 0.65f ) / 0.28f );
			float quintOut = uOut * uOut * uOut * ( uOut * ( uOut * 6.0f - 15.0f ) + 10.0f );
			float lifeEnv = fadeIn * ( 1.0f - quintOut );
			if ( lifeEnv <= 0.001f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}

			float2 uv = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float2 d = ( uv - 0.5f ) * 2.0f;

			float boxDist = max( abs( d.x ), abs( d.y ) );
			float radial = length( float2( d.x * 0.94f, d.y * 1.04f ) );
			float rim = saturate( max( smoothstep( 0.50f, 1.02f, boxDist ), smoothstep( 0.56f, 1.24f, radial ) ) );
			float cornerHalo = smoothstep( 0.68f, 1.28f, radial ) * smoothstep( 0.56f, 0.98f, boxDist );

			float2 uv1 = uv * float2( 1.93f, 1.27f ) + float2( Time * 0.013f, -Time * 0.0085f );
			float2 uv2 = uv * float2( 3.23f, 2.09f ) + float2( -Time * 0.0105f, Time * 0.0112f ) + float2( 0.37f, 0.61f );
			float2 uv3 = uv * float2( 1.38f, 1.08f ) + float2( -Time * 0.0068f, -Time * 0.0054f ) + float2( 0.19f, 0.73f );

			float2 s1 = float2( frameOff + ( 0.004f + 0.492f * frac( uv1.x ) ), 0.004f + 0.992f * frac( uv1.y ) );
			float2 s2 = float2( frameOff + ( 0.004f + 0.492f * frac( uv2.x ) ), 0.004f + 0.992f * frac( uv2.y ) );
			float2 s3 = float2( frameOff + ( 0.004f + 0.492f * frac( uv3.x ) ), 0.004f + 0.992f * frac( uv3.y ) );

			float4 n1 = tex2D( MapTexture, s1 );
			float4 n2 = tex2D( MapTexture, s2 );
			float4 n3 = tex2D( MapTexture, s3 );

			float mist = 0.52f * n1.g + 0.32f * n2.r + 0.16f * n3.b;
			float wisp = smoothstep( 0.48f, 0.88f, 0.50f * n1.r + 0.50f * n2.g );
			float stardustCloud = smoothstep( 0.44f, 0.86f, 0.58f * n3.g + 0.42f * n2.b ) * cornerHalo;
			float slowBreath = 0.86f + 0.14f * sin( Time * 0.85f );
			float cloudPulse = 0.62f + 0.38f * ( 0.5f + 0.5f * sin( Time * 0.58f + 0.9f ) );

			float pSync1 = smoothstep( 0.14f, 0.195f, t ) * ( 1.0f - smoothstep( 0.225f, 0.28f, t ) );
			float pSync2 = smoothstep( 0.42f, 0.490f, t ) * ( 1.0f - smoothstep( 0.535f, 0.60f, t ) );
			float phantomSync = max( pSync1, pSync2 );

			float3 deepObsidian = float3( 0.032f, 0.013f, 0.058f );
			float3 moonMistCol = float3( 0.150f, 0.074f, 0.236f );
			float3 coldRim = lerp( deepObsidian, moonMistCol, mist * 0.90f + phantomSync * 0.16f );
			float3 silverWisp = float3( 0.235f, 0.142f, 0.355f ) * wisp * ( 0.44f + 0.28f * phantomSync );

			float warmTint = smoothstep( 0.32f, 0.78f, n3.r );
			float3 stardustCol = lerp( float3( 0.46f, 0.38f, 0.68f ), float3( 0.66f, 0.56f, 0.42f ), warmTint * 0.55f );

			float baseVeil = 0.058f + 0.032f * mist;
			float rimAlpha = rim * ( 0.43f + 0.18f * mist + 0.08f * phantomSync ) * slowBreath;
			float cloudAlpha = stardustCloud * ( 0.14f + 0.09f * phantomSync ) * cloudPulse;
			float rawAlpha = min( 0.70f, baseVeil + rimAlpha + cloudAlpha );
			float alpha = saturate( rawAlpha * lifeEnv );

			float3 col = saturate( coldRim + silverWisp );
			col = lerp( col, stardustCol, saturate( ( cloudAlpha * 1.65f ) / max( rawAlpha, 0.001f ) ) );

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
