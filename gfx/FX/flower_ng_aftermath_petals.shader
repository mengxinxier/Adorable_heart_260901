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
			float uOut = saturate( ( t - 0.66f ) / 0.27f );
			float quintOut = uOut * uOut * uOut * ( uOut * ( uOut * 6.0f - 15.0f ) + 10.0f );
			float lifeEnv = fadeIn * ( 1.0f - quintOut );
			if ( lifeEnv <= 0.001f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}

			float2 uv = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float2 d = ( uv - 0.5f ) * 2.0f;
			float radial = length( float2( d.x * 0.95f, d.y * 1.05f ) );

			float fgMask = smoothstep( 0.32f, 0.85f, radial );
			float midMask = lerp( 0.42f, 1.0f, smoothstep( 0.24f, 0.82f, radial ) );
			float farMask = lerp( 0.52f, 1.0f, smoothstep( 0.20f, 0.86f, radial ) );

			float2 uvFg = uv * float2( 0.85f, 1.05f ) + float2( Time * 0.0145f + 0.019f * sin( Time * 0.46f + uv.y * 2.4f ), -Time * 0.0225f );
			float2 uvMid = uv * float2( 1.38f, 1.62f ) + float2( Time * 0.0088f + 0.011f * cos( Time * 0.37f + uv.y * 3.1f ), -Time * 0.0155f ) + float2( 0.37f, 0.19f );
			float2 uvFar = uv * float2( 2.25f, 2.55f ) + float2( -Time * 0.0062f + 0.007f * sin( Time * 0.54f + uv.y * 3.9f ), -Time * 0.0102f ) + float2( 0.61f, 0.47f );

			float2 sFg = float2( frameOff + ( 0.004f + 0.492f * frac( uvFg.x ) ), 0.004f + 0.992f * frac( uvFg.y ) );
			float2 sMid = float2( frameOff + ( 0.004f + 0.492f * frac( uvMid.x ) ), 0.004f + 0.992f * frac( uvMid.y ) );
			float2 sFar = float2( frameOff + ( 0.004f + 0.492f * frac( uvFar.x ) ), 0.004f + 0.992f * frac( uvFar.y ) );

			float4 pFg = tex2D( MapTexture, sFg );
			float4 pMid = tex2D( MapTexture, sMid );
			float4 pFar = tex2D( MapTexture, sFar );

			float farTwinkle = 0.78f + 0.22f * sin( Time * 2.35f + uv.y * 7.5f + pFar.b * 5.0f );
			float wFg = pFg.a * 0.88f * fgMask;
			float wMid = pMid.a * 0.78f * midMask;
			float wFar = pFar.a * 0.46f * farMask * farTwinkle;

			float rawA = saturate( wFg + wMid + wFar );
			if ( rawA <= 0.002f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}

			float sparse = smoothstep( ( 1.0f - lifeEnv ) * 0.34f, 0.84f, rawA );
			float alpha = saturate( rawA * 0.92f * lifeEnv * ( 0.44f + 0.56f * sparse ) );

			float3 col = ( pFg.rgb * wFg + pMid.rgb * wMid + pFar.rgb * wFar * 1.12f ) / max( wFg + wMid + wFar, 0.001f );
			col = saturate( col * 1.14f + float3( 0.048f, 0.018f, 0.078f ) );

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