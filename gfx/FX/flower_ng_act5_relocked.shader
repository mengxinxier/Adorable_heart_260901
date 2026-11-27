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
		VS_OUTPUT main( const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0f ) );
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
			float2 uv = v.vTexCoord;
			float4 baseCol = tex2D( MapTexture, uv );
			float3 col = baseCol.rgb;

			float dFace = length( ( uv - float2( 0.652f, 0.485f ) ) / float2( 0.22f, 0.40f ) );
			float faceSafe = smoothstep( 0.78f, 1.16f, dFace );
			float edgeSafe = smoothstep( 0.0f, 0.08f, uv.y ) * ( 1.0f - smoothstep( 0.90f, 1.0f, uv.y ) );

			float dGlobe = length( ( uv - float2( 0.309f, 0.710f ) ) / float2( 0.118f, 0.202f ) );
			float globeMask = 1.0f - smoothstep( 0.46f, 1.04f, dGlobe );
			float2 gRel = uv - float2( 0.309f, 0.710f );
			float gAng = atan2( gRel.y, gRel.x );
			float gRad = length( gRel );

			float crackRay = pow( saturate( 0.5f + 0.5f * sin( gAng * 9.0f + gRad * 34.0f - Time * 1.65f ) ), 4.0f );
			float frostPulse = 0.45f + 0.55f * pow( saturate( 0.5f + 0.5f * sin( Time * 1.85f ) ), 2.0f );
			float violetSwirl = 0.5f + 0.5f * sin( Time * 1.15f - uv.x * 13.0f + uv.y * 9.0f );
			col += ( float3( 0.075f, 0.095f, 0.165f ) * crackRay * frostPulse
			       + float3( 0.046f, 0.024f, 0.088f ) * violetSwirl ) * globeMask * edgeSafe;

			float dRose = length( ( uv - float2( 0.792f, 0.245f ) ) / float2( 0.088f, 0.128f ) );
			float roseGlow = ( 1.0f - smoothstep( 0.30f, 1.0f, dRose ) ) * ( 0.45f + 0.55f * sin( Time * 1.20f ) ) * faceSafe;
			col += float3( 0.016f, 0.056f, 0.050f ) * roseGlow * edgeSafe;

			float diagCoord = uv.x * 1.35f + uv.y * 0.62f;
			float b1Arg = ( diagCoord - 0.52f - 0.03f * sin( Time * 0.45f ) ) * 9.5f;
			float b2Arg = ( diagCoord - 1.38f + 0.03f * cos( Time * 0.38f ) ) * 10.5f;
			float beam1 = exp( -( b1Arg * b1Arg ) );
			float beam2 = exp( -( b2Arg * b2Arg ) );
			float moonShaft = ( beam1 + beam2 * 0.85f ) * ( 0.55f + 0.45f * sin( Time * 0.75f + uv.y * 3.0f ) ) * faceSafe * edgeSafe;
			col += float3( 0.048f, 0.044f, 0.082f ) * moonShaft;

			float outerArch = smoothstep( 0.24f, 0.48f, abs( uv.x - 0.55f ) ) * faceSafe * edgeSafe;
			float phaseM1 = uv.y * 3.4f + uv.x * 4.2f + Time * 0.58f;
			float phaseM2 = uv.y * 4.1f - uv.x * 3.1f - Time * 0.44f;
			float edgeMist = ( 0.5f + 0.5f * sin( phaseM1 ) ) * ( 0.5f + 0.5f * cos( phaseM2 ) );
			float deepPulse = 0.5f + 0.5f * sin( Time * 0.92f );
			col *= 1.0f - 0.045f * deepPulse * faceSafe * edgeSafe;
			col += float3( 0.042f, 0.025f, 0.078f ) * edgeMist * outerArch;

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
