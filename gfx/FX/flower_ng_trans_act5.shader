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
		float quinticEase( float x )
		{
			float u = saturate( x );
			return u * u * u * ( u * ( u * 6.0f - 15.0f ) + 10.0f );
		}

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
			float cloud = ( drv.r * 0.60f + drv.g * 0.40f ) - 0.5f;
			float silkWisp = smoothstep( 0.34f, 0.88f, drv.g * 0.62f + drv.r * 0.38f );

			float dGlobe = length( ( localUV - float2( 0.309f, 0.710f ) ) / float2( 0.24f, 0.34f ) );
			float dFace  = length( ( localUV - float2( 0.652f, 0.485f ) ) / float2( 0.28f, 0.42f ) );
			float orgGlobe = max( 0.0f, dGlobe + cloud * 0.26f );
			float orgFace  = max( 0.0f, dFace  + cloud * 0.26f );

			float holdBlackout = 1.0f - smoothstep( 0.124f, 0.148f, t );
			float quietCore = ( 1.0f - smoothstep( 0.015f, 0.124f, t ) ) * exp( -radial * radial * 4.2f );

			float qGlobe = quinticEase( ( t - 0.124f ) / ( 0.397f - 0.124f ) );
			float qFace  = quinticEase( ( t - 0.171f ) / ( 0.485f - 0.171f ) );
			float qOuter = quinticEase( ( t - 0.485f ) / ( 0.947f - 0.485f ) );

			float spreadG = 0.22f + qGlobe * 1.15f;
			float clearGlobe = exp( -orgGlobe * orgGlobe / ( spreadG * spreadG ) ) * saturate( qGlobe * 2.15f ) * 0.94f;

			float eyeGlimmer = quinticEase( ( t - 0.165f ) / ( 0.310f - 0.165f ) ) * exp( -orgFace * orgFace * 1.85f ) * 0.38f;
			float spreadF = 0.26f + qFace * 1.18f;
			float clearFace = max( eyeGlimmer, exp( -orgFace * orgFace / ( spreadF * spreadF ) ) * saturate( qFace * 1.35f ) * 0.94f );

			float dualClear = 1.0f - ( 1.0f - clearGlobe ) * ( 1.0f - clearFace );
			float focusVeil = 1.0f - dualClear;

			float archDist = saturate( min( orgGlobe, orgFace ) * 0.42f + radial * 0.58f + cloud * 0.14f );
			float inkWave = smoothstep( qOuter * 1.28f - 0.34f, qOuter * 1.28f + 0.22f, archDist );
			float outerFade = focusVeil * inkWave * ( 1.0f - qOuter );
			float tailZero = 1.0f - smoothstep( 0.915f, 0.950f, t );

			float veilAlpha = lerp( outerFade, 1.0f, holdBlackout );
			veilAlpha = saturate( veilAlpha * tailZero );

			float3 deepObsidian = lerp( float3( 0.014f, 0.009f, 0.025f ), float3( 0.036f, 0.022f, 0.062f ), drv.g );
			float3 inkVelvet = deepObsidian + float3( 0.065f, 0.038f, 0.115f ) * silkWisp * ( 0.35f + 0.65f * veilAlpha );
			inkVelvet += float3( 0.075f, 0.052f, 0.135f ) * quietCore * ( 0.65f + 0.35f * drv.r );

			float globeHaloEnv = smoothstep( 0.128f, 0.225f, t ) * ( 1.0f - smoothstep( 0.360f, 0.620f, t ) );
			float globeRim = exp( -pow( orgGlobe - ( 0.18f + qGlobe * 0.68f ), 2.0f ) * 5.2f ) * globeHaloEnv * ( 0.68f + 0.32f * drv.r );

			float faceHaloEnv = smoothstep( 0.172f, 0.285f, t ) * ( 1.0f - smoothstep( 0.450f, 0.760f, t ) );
			float faceRim = exp( -pow( orgFace - ( 0.16f + qFace * 0.72f ), 2.0f ) * 4.6f ) * faceHaloEnv * ( 0.68f + 0.32f * drv.g );

			float3 warmMoonGold = float3( 0.84f, 0.66f, 0.36f ) * globeRim * 0.34f;
			float3 silverViolet = float3( 0.56f, 0.46f, 0.84f ) * faceRim * 0.32f;
			float3 col = saturate( inkVelvet + warmMoonGold + silverViolet );

			return float4( col, veilAlpha ) * Color;
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
