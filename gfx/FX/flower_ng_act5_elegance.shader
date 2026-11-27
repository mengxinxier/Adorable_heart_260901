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
			float dFace = length( ( uv - float2( 0.652f, 0.485f ) ) / float2( 0.22f, 0.40f ) );
			float faceSafe = smoothstep( 0.78f, 1.16f, dFace );
			float edgeSafe = smoothstep( 0.0f, 0.08f, uv.y ) * ( 1.0f - smoothstep( 0.90f, 1.0f, uv.y ) )
			               * smoothstep( 0.0f, 0.04f, uv.x ) * ( 1.0f - smoothstep( 0.96f, 1.0f, uv.x ) );

			float4 baseCol = tex2D( MapTexture, uv );
			float3 col = baseCol.rgb;

			float dGlobe = length( ( uv - float2( 0.309f, 0.710f ) ) / float2( 0.112f, 0.196f ) );
			float globeMask = 1.0f - smoothstep( 0.52f, 1.02f, dGlobe );
			float amberBreath = 0.5f + 0.5f * sin( Time * 0.82f );
			col += float3( 0.036f, 0.024f, 0.009f ) * globeMask * amberBreath * edgeSafe;

			float phaseA = uv.y * 1.9f + uv.x * 2.7f + Time * 0.24f;
			float phaseB = uv.y * 2.4f - uv.x * 1.8f - Time * 0.19f;
			float archSheen = smoothstep( 0.38f, 0.94f, ( 0.5f + 0.5f * sin( phaseA ) ) * ( 0.5f + 0.5f * cos( phaseB ) ) ) * faceSafe * edgeSafe;
			col += float3( 0.020f, 0.017f, 0.028f ) * archSheen;

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
