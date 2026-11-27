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
			float2 uv = v.vAnimData.xy;
			float t = v.vAnimData.z;
			float frameOff = v.vAnimData.w;
			float sec = t * 2.15f;

			// Locked portrait UV anchors (1280x720 Option A master coordinates)
			float2 eyeL  = float2( 0.5740f, 0.4812f );
			float2 eyeR  = float2( 0.7064f, 0.4538f );
			float2 tip   = float2( 0.7195f, 0.6485f );
			float2 globe = float2( 0.3080f, 0.7050f );
			float2 face  = float2( 0.6420f, 0.5000f );
			float2 pivot = float2( 0.6200f, 0.5200f );

			// Beat 3 (0.30s..0.95s): Crisp 1.13x push-in zoom around central axis + rapid damped glass micro-shake
			float dt = max( 0.0f, sec - 0.30f );
			float impactGate = smoothstep( 0.290f, 0.308f, sec ) * ( 1.0f - smoothstep( 0.88f, 1.32f, sec ) );
			float zoomEnv = exp( -5.2f * dt ) * ( 0.78f + 0.22f * cos( 13.5f * dt ) );
			float slamZoom = 1.0f + 0.130f * zoomEnv * impactGate;

			float shakeEnv = exp( -9.5f * dt ) * impactGate;
			float2 shakeOff = float2(
				( sin( dt * 96.0f ) * 0.72f + sin( dt * 163.0f ) * 0.28f ) * 0.0095f,
				( cos( dt * 82.0f ) * 0.72f - sin( dt * 139.0f ) * 0.28f ) * 0.0080f
			) * shakeEnv;

			// Beat 4 & permanent state (> 0.95s): Aristocratic poised micro-breathing zoom
			float settle = smoothstep( 0.85f, 1.35f, sec );
			float breathZoom = 1.0f + 0.0045f * sin( Time * 0.72f ) * settle;

			float2 suv = ( uv - pivot ) / ( slamZoom * breathZoom ) + pivot + shakeOff;
			suv = clamp( suv, 0.002f, 0.998f );

			// Smooth outer border lock to pure black across zoom and micro-shake
			float frameMask = smoothstep( 0.0f, 0.032f, uv.x ) * ( 1.0f - smoothstep( 0.968f, 1.0f, uv.x ) )
			                * smoothstep( 0.0f, 0.040f, uv.y ) * ( 1.0f - smoothstep( 0.960f, 1.0f, uv.y ) );

			float2 sampleBase = float2( frameOff + suv.x * 0.5f, suv.y );
			float4 baseCol = tex2D( MapTexture, sampleBase );
			float3 col = baseCol.rgb;

			// Face & eyes razor-sharp protection zone
			float dFace = length( ( suv - face ) / float2( 0.165f, 0.245f ) );
			float faceSafe = smoothstep( 0.68f, 1.14f, dFace );

			// Fingertip epicenter radial chromatic dispersion + 0.53s crystalline aftershock
			float dAfter = ( sec - 0.53f ) * 22.0f;
			float afterShock = exp( -dAfter * dAfter );
			float caEnv = ( exp( -7.2f * dt ) * smoothstep( 0.295f, 0.308f, sec ) + afterShock * 0.62f )
			            * ( 1.0f - smoothstep( 0.88f, 1.18f, sec ) );

			float2 dTipVec = suv - tip;
			float2 dTipEq = float2( dTipVec.x * 1.7778f, dTipVec.y );
			float tipRad = length( dTipEq );
			float2 dirTip = dTipVec / ( length( dTipVec ) + 0.0001f );

			float dWave1 = ( tipRad - dt * 3.2f ) * 14.0f;
			float shockRing1 = exp( -dWave1 * dWave1 ) * exp( -4.2f * dt ) * smoothstep( 0.296f, 0.308f, sec );
			float dtAfter = max( 0.0f, sec - 0.50f );
			float dWave2 = ( tipRad - dtAfter * 2.8f ) * 16.0f;
			float shockRing2 = exp( -dWave2 * dWave2 ) * afterShock;
			float shockWave = saturate( shockRing1 + shockRing2 * 0.85f );

			float caAmt = ( 0.0016f + 0.0112f * faceSafe * ( 0.55f + 0.45f * shockWave ) ) * caEnv;
			float2 uvR = clamp( suv + dirTip * caAmt, 0.002f, 0.998f );
			float2 uvB = clamp( suv - dirTip * caAmt, 0.002f, 0.998f );
			float rCh = tex2D( MapTexture, float2( frameOff + uvR.x * 0.5f, uvR.y ) ).r;
			float bCh = tex2D( MapTexture, float2( frameOff + uvB.x * 0.5f, uvB.y ) ).b;
			col.r = lerp( col.r, rCh, saturate( caEnv ) * 0.88f );
			col.b = lerp( col.b, bCh, saturate( caEnv ) * 0.92f );
			col += float3( 0.19f, 0.21f, 0.33f ) * shockWave * ( 0.32f + 0.68f * faceSafe ) * frameMask;

			// Natural -5.8 deg eye-axis alignment (cosA = 0.9949, sinA = -0.1011; right eye higher than left eye)
			float2 dEyeL = float2( ( suv.x - eyeL.x ) * 1.7778f, suv.y - eyeL.y );
			float2 dEyeR = float2( ( suv.x - eyeR.x ) * 1.7778f, suv.y - eyeR.y );
			float2 gTiltL = float2( dEyeL.x * 0.9949f + dEyeL.y * ( -0.1011f ), -dEyeL.x * ( -0.1011f ) + dEyeL.y * 0.9949f );
			float2 gTiltR = float2( dEyeR.x * 0.9949f + dEyeR.y * ( -0.1011f ), -dEyeR.x * ( -0.1011f ) + dEyeR.y * 0.9949f );

			// Tapered almond eyelid & iris geometry (strictly zero circular orb bloom)
			float taperL = max( 0.35f, 1.0f - 0.55f * saturate( abs( gTiltL.x ) / 0.056f ) );
			float taperR = max( 0.35f, 1.0f - 0.55f * saturate( abs( gTiltR.x ) / 0.056f ) );
			float mAlmondL = length( float2( gTiltL.x / 0.054f, gTiltL.y / ( 0.025f * taperL ) ) );
			float mAlmondR = length( float2( gTiltR.x / 0.054f, gTiltR.y / ( 0.025f * taperR ) ) );
			float mIrisL   = length( float2( gTiltL.x / 0.036f, gTiltL.y / ( 0.023f * taperL ) ) );
			float mIrisR   = length( float2( gTiltR.x / 0.036f, gTiltR.y / ( 0.023f * taperR ) ) );

			float eyeAlmond = max( 1.0f - smoothstep( 0.48f, 1.00f, mAlmondL ), 1.0f - smoothstep( 0.48f, 1.00f, mAlmondR ) );
			float eyeCore   = max( 1.0f - smoothstep( 0.16f, 0.92f, mIrisL ),   1.0f - smoothstep( 0.16f, 0.92f, mIrisR ) ) * eyeAlmond;
			float eyePin    = max( 1.0f - smoothstep( 0.00f, 0.30f, mIrisL ),   1.0f - smoothstep( 0.00f, 0.30f, mIrisR ) ) * eyeAlmond;
			float glintL    = ( 1.0f - smoothstep( 0.0009f, 0.0045f, abs( gTiltL.y + 0.0018f ) ) ) * ( 1.0f - smoothstep( 0.006f, 0.045f, abs( gTiltL.x ) ) );
			float glintR    = ( 1.0f - smoothstep( 0.0009f, 0.0045f, abs( gTiltR.y + 0.0018f ) ) ) * ( 1.0f - smoothstep( 0.006f, 0.045f, abs( gTiltR.x ) ) );
			float eyeGlint  = max( glintL, glintR ) * eyeAlmond;

			// Beat 2 (0.06s..0.30s): Deep chiaroscuro lock with subtle facial silhouette & clear luminous amethyst eyes
			float darkHold = 1.0f - smoothstep( 0.290f, 0.316f, sec );
			float faceContour = ( 1.0f - smoothstep( 0.42f, 1.05f, dFace ) ) * 0.042f;
			float eyeKeep = saturate( max( eyeAlmond * 0.85f, max( eyeCore * 1.25f, eyeGlint * 1.35f ) ) );
			col *= lerp( 1.0f, lerp( 0.032f + faceContour, 1.36f, eyeKeep ), darkHold );

			float beat2Eyes = smoothstep( 0.062f, 0.135f, sec ) * ( 1.0f - smoothstep( 0.33f, 0.58f, sec ) );
			float eyeBreath = 0.24f + 0.14f * sin( Time * 1.85f );
			float eyeBoost = beat2Eyes * 1.42f + caEnv * 0.56f + eyeBreath * settle;
			col += ( float3( 0.38f, 0.16f, 0.70f ) * eyeCore
			       + float3( 0.70f, 0.52f, 0.98f ) * eyePin
			       + float3( 0.92f, 0.94f, 1.00f ) * eyeGlint * 0.92f ) * eyeBoost * 0.54f * frameMask;

			// Beat 3 (0.30s): Cinema cold-silver high-contrast flash punch
			float flashPunch = exp( -14.0f * dt ) * smoothstep( 0.296f, 0.306f, sec );
			float3 contrastCol = saturate( ( col - 0.18f ) * ( 1.0f + 0.28f * flashPunch ) + 0.18f );
			col = lerp( col, contrastCol, flashPunch * 0.75f );
			col += float3( 0.22f, 0.23f, 0.34f ) * flashPunch * ( 0.38f + 0.62f * faceSafe ) * frameMask;

			// Fingertip fracture epicenter fine silver-violet crystalline glints
			float tipAng = atan2( dTipEq.y, dTipEq.x );
			float tipWaveBase = max( 0.0001f, saturate( 0.5f + 0.5f * sin( tipAng * 7.0f + tipRad * 18.0f - Time * 1.35f ) ) );
			float tipGlintWave = pow( tipWaveBase, 6.0f );
			float tipZone = smoothstep( 0.012f, 0.055f, tipRad ) * ( 1.0f - smoothstep( 0.095f, 0.30f, tipRad ) );
			float tipPulse = ( 0.28f + 0.18f * sin( Time * 1.65f + 0.8f ) ) * settle + caEnv * 1.35f;
			col += float3( 0.18f, 0.17f, 0.30f ) * tipGlintWave * tipZone * tipPulse * ( 1.0f - darkHold ) * frameMask;

			// Left extinguished frosted crystal globe: smooth polar spiral ice-blue & dark-violet current (zero grid dots)
			float2 gVec = ( suv - globe ) / float2( 0.112f, 0.192f );
			float gRad = length( gVec );
			float gAng = atan2( gVec.y, gVec.x );
			float globeMask = ( 1.0f - smoothstep( 0.58f, 1.00f, gRad ) ) * ( 1.0f - darkHold * 0.92f );
			float spiralA = 0.5f + 0.5f * sin( gAng * 2.0f - gRad * 5.2f + Time * 1.15f );
			float spiralB = 0.5f + 0.5f * sin( gAng * 3.0f + gRad * 3.8f - Time * 0.82f + 1.4f );
			float frostRim = smoothstep( 0.52f, 0.88f, gRad ) * ( 1.0f - smoothstep( 0.88f, 1.02f, gRad ) );
			float3 globeTint = lerp( float3( 0.036f, 0.054f, 0.132f ), float3( 0.084f, 0.124f, 0.218f ), spiralA * 0.65f + spiralB * 0.35f );
			col += ( globeTint * ( 0.45f + 0.55f * spiralA ) + float3( 0.072f, 0.094f, 0.172f ) * frostRim * spiralB )
			     * globeMask * ( 0.85f + 0.45f * caEnv ) * frameMask;

			// Outer gothic deep-violet mist cushion using additive oblique fluid waves (zero standing-wave grid)
			float edgeDist = length( ( suv - float2( 0.52f, 0.50f ) ) / float2( 0.50f, 0.52f ) );
			float outerFrame = smoothstep( 0.58f, 1.02f, edgeDist ) * faceSafe * frameMask;
			float mistFlow = 0.50f
			               + 0.28f * sin( suv.x * 3.6f + suv.y * 2.7f + Time * 0.55f )
			               + 0.22f * sin( suv.x * 2.3f - suv.y * 3.4f - Time * 0.42f + 1.1f );
			col += float3( 0.044f, 0.020f, 0.086f ) * mistFlow * outerFrame * settle;

			col *= frameMask;
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
