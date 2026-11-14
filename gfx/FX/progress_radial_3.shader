Includes = {
}

PixelShader =
{
	Samplers =
	{
		TextureOne =
		{
			Index = 0
			MagFilter = "Point"
			MinFilter = "Point"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Wrap"
		}
		TextureTwo =
		{
			Index = 1
			MagFilter = "Point"
			MinFilter = "Point"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Wrap"
		}
	}
}


VertexStruct VS_INPUT
{
    float4 vPosition  : POSITION;
    float2 vTexCoord  : TEXCOORD0;
};

VertexStruct VS_OUTPUT
{
    float4  vPosition : PDX_POSITION;
    float2  vTexCoord0 : TEXCOORD0;
};


ConstantBuffer( 0, 0 )
{
	float4x4 WorldViewProjectionMatrix; 
	float4 vFirstColor;
	float4 vSecondColor;
	float CurrentState;
};


VertexShader =
{
	MainCode VertexShader
	[[
		
		VS_OUTPUT main(const VS_INPUT v )
		{
			VS_OUTPUT Out;
		   	Out.vPosition  = mul( WorldViewProjectionMatrix, v.vPosition );
			Out.vTexCoord0  = v.vTexCoord;
		
			return Out;
		}
		
	]]
}

PixelShader =
{
	MainCode PixelColor
	[[
		
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			if( v.vTexCoord0.x <= CurrentState )
				return vFirstColor;
			else
				return vSecondColor;
		}
		
	]]

	MainCode PixelTexture
	[[
		
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			// Sample upright: HOI4 feeds bottom-up texcoords here, so V is unflipped.
			// If the picture comes out upside down, delete the "1.0f -" on the next line.
			float2 uv = float2( v.vTexCoord0.x, 1.0f - v.vTexCoord0.y );

			// 0 = 12 o'clock, positive = clockwise (computed in the same frame as uv)
			float2 vDir = float2( 0.5f, 0.5f ) - uv;
			float vAngle = atan2( -vDir.x, vDir.y );
			vAngle = ( vAngle < 0.0f ) ? vAngle + 6.2831853f : vAngle;

			// Move the sweep start from 12 o'clock to 6 o'clock; direction is unchanged.
			float vSweep = vAngle + 3.14159265f;
			vSweep = ( vSweep >= 6.2831853f ) ? vSweep - 6.2831853f : vSweep;

			float vLerp = saturate( ( vSweep - CurrentState* 6.2831853f ) * 50.f );
			float4 vOne = tex2D( TextureOne, uv.xy );
			float4 vTwo = tex2D( TextureTwo, uv.xy );
			return lerp( vOne, vTwo, vLerp );
		}
		
	]]
}


BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
}


Effect Color
{
	VertexShader = "VertexShader"
	PixelShader = "PixelColor"
}

Effect Texture
{
	VertexShader = "VertexShader"
	PixelShader = "PixelTexture"
}
