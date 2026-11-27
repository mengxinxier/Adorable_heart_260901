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
			Out.vTexCoord = v.vTexCoord;
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
			float edgeLock = smoothstep( 0.0f, 0.04f, uv.x ) * ( 1.0f - smoothstep( 0.96f, 1.0f, uv.x ) )
			               * smoothstep( 0.0f, 0.04f, uv.y ) * ( 1.0f - smoothstep( 0.96f, 1.0f, uv.y ) );
			float4 baseCol = tex2D( MapTexture, uv );
			float leftMask = ( 1.0f - smoothstep( 0.44f, 0.54f, uv.x ) ) * ( 1.0f - smoothstep( 0.68f, 0.80f, uv.y ) );
			float warmBreath = ( 0.5f + 0.5f * sin( Time * 0.55f + uv.x * 2.6f - uv.y * 1.9f ) ) * leftMask * edgeLock;
			float sunGlint = ( 0.5f + 0.5f * sin( Time * 0.38f + uv.y * 3.4f ) ) * edgeLock;
			float3 col = baseCol.rgb + float3( 0.014f, 0.010f, 0.004f ) * warmBreath + float3( 0.005f, 0.004f, 0.002f ) * sunGlint;
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
