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
		// Non-uniform tempered-crystal radial fracture ray using signed angular delta (single razor line, zero hollow double-ring)
		float glassRay( float ang, float rad, float targetAng, float bend, float maxLen, float baseW )
		{
			float da = atan2( sin( ang - targetAng ), cos( ang - targetAng ) );
			float kink = sin( rad * 18.0f + targetAng * 7.0f ) * 0.013f + cos( rad * 34.0f - targetAng * 5.0f ) * 0.006f;
			float perp = abs( da * max( rad, 0.028f ) + kink * bend * smoothstep( 0.035f, 0.24f, rad ) );
			float w = baseW * ( 1.0f - 0.56f * saturate( rad / maxLen ) );
			float core = 1.0f - smoothstep( w * 0.26f, w, perp );
			float lenFade = 1.0f - smoothstep( maxLen * 0.72f, maxLen, rad );
			return core * lenFade * step( abs( da ), 0.34f );
		}

		// Secondary dendritic ice-crystal fork anchored seamlessly onto a primary glassRay spine
		float glassBranch( float2 dp, float targetAng, float bend, float branchR, float forkAng, float forkLen, float baseW )
		{
			float2 dir0 = float2( cos( targetAng ), sin( targetAng ) );
			float2 nrm0 = float2( -dir0.y, dir0.x );
			float kink0 = ( sin( branchR * 18.0f + targetAng * 7.0f ) * 0.013f + cos( branchR * 34.0f - targetAng * 5.0f ) * 0.006f )
			            * bend * smoothstep( 0.035f, 0.24f, branchR );
			float2 bPos = dir0 * branchR - nrm0 * kink0;
			float bAng = targetAng + forkAng;
			float2 bDir = float2( cos( bAng ), sin( bAng ) );
			float2 bNrm = float2( -bDir.y, bDir.x );
			float2 rel = dp - bPos;
			float along = rel.x * bDir.x + rel.y * bDir.y;
			float subKink = sin( along * 26.0f + bAng * 5.0f ) * 0.0042f * smoothstep( 0.0f, 0.08f, along );
			float perp = abs( rel.x * bNrm.x + rel.y * bNrm.y + subKink );
			float w = baseW * ( 1.0f - 0.65f * saturate( along / forkLen ) );
			float core = 1.0f - smoothstep( w * 0.25f, w, perp );
			float span = smoothstep( -0.003f, 0.010f, along ) * ( 1.0f - smoothstep( forkLen * 0.68f, forkLen, along ) );
			return core * span;
		}

		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float t = v.vAnimData.z;
			if ( t >= 0.945f )
			{
				return float4( 0.0f, 0.0f, 0.0f, 0.0f );
			}

			float sec = t * 2.15f;
			float2 uv = v.vAnimData.xy;
			float frameOff = v.vAnimData.w;
			float2 sampleUV = float2( frameOff + clamp( uv.x, 0.002f, 0.998f ) * 0.5f, clamp( uv.y, 0.002f, 0.998f ) );
			float4 drv = tex2D( MapTexture, sampleUV );
			float nCloud = drv.r * 0.55f + drv.g * 0.45f;

			// Locked 1920x1080 fullscreen UV anchors (u_scr = 1/6 + u*2/3, v_scr = 2/15 + v*2/3)
			float2 tipScr  = float2( 0.6463f, 0.5657f );
			float2 eyeLScr = float2( 0.5493f, 0.4541f );
			float2 eyeRScr = float2( 0.6376f, 0.4359f );
			float2 faceScr = float2( 0.5947f, 0.4667f );

			// Aspect-corrected vector from fingertip shatter epicenter
			float2 dp = float2( ( uv.x - tipScr.x ) * 1.7778f, uv.y - tipScr.y );
			float rad = length( dp );
			float ang = atan2( dp.y, dp.x );

			// Face & eyes protection zone (keeps fingertip impact crisp while softening rays across facial features)
			float dFaceScr = length( float2( ( uv.x - faceScr.x ) * 1.7778f, uv.y - faceScr.y ) / float2( 0.1956f, 0.1633f ) );
			float faceClear = smoothstep( 0.62f, 1.18f, dFaceScr );
			float faceAvoid = max( faceClear, 1.0f - smoothstep( 0.025f, 0.115f, rad ) );

			// 11 non-uniform tempered-crystal primary cracks radiating from fingertip (routed clear of pupil centers)
			float cr = 0.0f;
			cr = max( cr, glassRay( ang, rad, -2.92f, 0.95f, 1.34f, 0.0048f ) );
			cr = max( cr, glassRay( ang, rad, -2.38f, 1.05f, 1.28f, 0.0042f ) * ( 0.25f + 0.75f * faceAvoid ) );
			cr = max( cr, glassRay( ang, rad, -2.04f, 0.78f, 1.18f, 0.0046f ) * ( 0.30f + 0.70f * faceAvoid ) );
			cr = max( cr, glassRay( ang, rad, -1.42f, 1.10f, 0.96f, 0.0044f ) );
			cr = max( cr, glassRay( ang, rad, -0.96f, 0.85f, 0.92f, 0.0052f ) );
			cr = max( cr, glassRay( ang, rad, -0.42f, 1.00f, 0.82f, 0.0044f ) );
			cr = max( cr, glassRay( ang, rad,  0.14f, 0.82f, 0.78f, 0.0048f ) );
			cr = max( cr, glassRay( ang, rad,  0.68f, 1.12f, 0.86f, 0.0045f ) );
			cr = max( cr, glassRay( ang, rad,  1.22f, 0.90f, 0.76f, 0.0046f ) );
			cr = max( cr, glassRay( ang, rad,  1.98f, 1.05f, 0.88f, 0.0044f ) );
			cr = max( cr, glassRay( ang, rad,  2.68f, 0.88f, 1.36f, 0.0054f ) );

			// Authentic secondary ice-crystal forks branching seamlessly from primary fracture spines
			float br = 0.0f;
			br = max( br, glassBranch( dp, -2.92f, 0.95f, 0.30f,  0.34f, 0.46f, 0.0034f ) );
			br = max( br, glassBranch( dp, -2.92f, 0.95f, 0.64f, -0.28f, 0.42f, 0.0030f ) );
			br = max( br, glassBranch( dp, -1.42f, 1.10f, 0.26f, -0.36f, 0.36f, 0.0032f ) );
			br = max( br, glassBranch( dp, -0.42f, 1.00f, 0.22f,  0.38f, 0.34f, 0.0032f ) );
			br = max( br, glassBranch( dp,  0.68f, 1.12f, 0.24f, -0.34f, 0.36f, 0.0032f ) );
			br = max( br, glassBranch( dp,  1.98f, 1.05f, 0.28f,  0.35f, 0.38f, 0.0032f ) );
			br = max( br, glassBranch( dp,  2.68f, 0.88f, 0.40f, -0.32f, 0.48f, 0.0035f ) );
			float glassCrack = saturate( max( cr, br * 0.82f * faceClear ) ) * ( 0.16f + 0.84f * faceAvoid );

			// Beat 1 (0.00s..0.062s): Razor cold-silver & amethyst diagonal chord slicing directly through tipScr + parallel secondary filament
			float slashPerp  = dp.x * 0.5000f + dp.y * 0.8660f;
			float slashAlong = dp.x * 0.8660f - dp.y * 0.5000f;
			float slashMicro = ( drv.r - 0.5f ) * 0.0045f + sin( slashAlong * 28.0f ) * 0.0014f;
			float slashSweep = smoothstep( -1.35f, 0.95f, slashAlong + ( sec / 0.030f ) * 0.95f );
			float slashTaper = 1.0f - smoothstep( 0.68f, 1.52f, abs( slashAlong ) );
			float sDist      = abs( slashPerp + slashMicro );
			float slashBlade = ( 1.0f - smoothstep( 0.0010f, 0.0068f, sDist ) ) * slashTaper;
			float slashHalo  = ( 1.0f - smoothstep( 0.0035f, 0.0360f, sDist ) ) * ( 0.72f + 0.28f * drv.g ) * slashTaper;
			float slashSub   = ( 1.0f - smoothstep( 0.0007f, 0.0038f, abs( slashPerp - 0.022f + slashMicro * 1.25f ) ) )
			                 * ( 1.0f - smoothstep( 0.46f, 1.18f, abs( slashAlong - 0.06f ) ) ) * 0.82f;
			float slashNode  = exp( -rad * 11.0f ) * 0.52f;
			float beat1      = smoothstep( 0.000f, 0.008f, sec ) * ( 1.0f - smoothstep( 0.036f, 0.062f, sec ) ) * slashSweep;

			// Beat 2 (0.062s..0.295s): -5.8 deg almond eye windows on pitch-black obsidian (zero circular halo)
			float2 deL = float2( ( uv.x - eyeLScr.x ) * 1.7778f, uv.y - eyeLScr.y );
			float2 deR = float2( ( uv.x - eyeRScr.x ) * 1.7778f, uv.y - eyeRScr.y );
			float2 teL = float2( deL.x * 0.9949f + deL.y * ( -0.1011f ), -deL.x * ( -0.1011f ) + deL.y * 0.9949f );
			float2 teR = float2( deR.x * 0.9949f + deR.y * ( -0.1011f ), -deR.x * ( -0.1011f ) + deR.y * 0.9949f );
			float winTaperL = max( 0.36f, 1.0f - 0.54f * saturate( abs( teL.x ) / 0.048f ) );
			float winTaperR = max( 0.36f, 1.0f - 0.54f * saturate( abs( teR.x ) / 0.048f ) );
			float mEL = length( float2( teL.x / 0.046f, teL.y / ( 0.022f * winTaperL ) ) );
			float mER = length( float2( teR.x / 0.046f, teR.y / ( 0.022f * winTaperR ) ) );
			float eyeWin = saturate( max( 1.0f - smoothstep( 0.42f, 1.00f, mEL ), 1.0f - smoothstep( 0.42f, 1.00f, mER ) ) )
			             * smoothstep( 0.062f, 0.132f, sec );

			// Fingertip stress pre-fracture propagation (0.18s subtle onset -> 0.27s clear radiating hairlines)
			float preProg    = smoothstep( 0.172f, 0.278f, sec );
			float preFadeOut = 1.0f - smoothstep( 0.296f, 0.312f, sec );
			float preReach   = 0.045f + 0.385f * preProg;
			float preMask    = 1.0f - smoothstep( preReach * 0.55f, preReach, rad );
			float preTipPin  = exp( -rad * 26.0f ) * smoothstep( 0.176f, 0.255f, sec ) * 0.72f;
			float preCrack   = saturate( glassCrack * preMask * ( 0.12f + 0.84f * preProg ) + preTipPin )
			                 * smoothstep( 0.170f, 0.186f, sec ) * preFadeOut;

			// Beat 3 (0.30s..0.95s): Rapid core burst (~0.775 at 0.315s) + full-screen polygonal shard peel (> 2.3 by 0.50s)
			float dt = max( 0.0f, sec - 0.30f );
			float burstInit  = smoothstep( 0.296f, 0.316f, sec ) * 0.78f;
			float burstSweep = smoothstep( 0.312f, 0.495f, sec ) * 1.62f;
			float peelFront  = burstInit + burstSweep;
			// Strictly 2*PI periodic polygonal crystal shard contour (zero branch-cut step at +/-PI)
			float shardOffset = abs( sin( ang * 3.0f + 0.42f ) ) * 0.115f
			                  + abs( cos( ang * 5.0f - 0.85f ) ) * 0.075f
			                  + abs( sin( ang * 8.0f + 1.74f ) ) * 0.042f;
			float shardEdgeDist = peelFront - ( rad + shardOffset );
			float cleared = smoothstep( -0.014f, 0.082f, shardEdgeDist ) * smoothstep( 0.296f, 0.310f, sec );

			// Crisp silver-violet polygonal rim glint along the retreating obsidian curtain edge
			float shardRim = ( 1.0f - smoothstep( 0.0f, 0.022f, abs( shardEdgeDist ) ) )
			               * smoothstep( 0.296f, 0.308f, sec ) * ( 1.0f - smoothstep( 0.45f, 0.60f, sec ) );

			float darkMask = ( 1.0f - cleared ) * ( 1.0f - eyeWin * 0.995f );
			darkMask *= ( 1.0f - smoothstep( 0.50f, 0.68f, sec ) );

			// 8-pointed cold-silver crystalline starburst at fingertip epicenter + 0.53s electric aftershock
			float octMainBase = max( 0.0001f, saturate( abs( cos( ang * 4.0f + 0.28f ) ) ) );
			float octSubBase  = max( 0.0001f, saturate( abs( cos( ang * 4.0f + 1.065f ) ) ) );
			float starRays = pow( octMainBase, 18.0f ) * exp( -rad * 5.2f ) * 1.25f
			               + pow( octSubBase, 24.0f ) * exp( -rad * 8.5f ) * 0.55f;
			float dAfter = ( sec - 0.53f ) * 24.0f;
			float afterShock = exp( -dAfter * dAfter );
			float starEnv = exp( -13.5f * dt ) * smoothstep( 0.296f, 0.305f, sec ) + afterShock * 0.54f;
			float impactCore = ( exp( -rad * 18.0f ) * 0.92f + starRays ) * starEnv;

			// Beat 4 (0.95s..2.15s): Outer-to-inner frost thaw (~0.25..0.30 alpha hairline at 1.05s, zeroed by 1.65s)
			float baseCrackEnv  = ( 0.34f + 0.66f * exp( -3.8f * dt ) ) * smoothstep( 0.296f, 0.308f, sec ) + afterShock * 0.58f;
			float frostDissolve = 1.0f - smoothstep( 0.92f, 1.62f, sec );
			float thawRadius    = lerp( 0.22f, 1.85f, frostDissolve );
			float thawMask      = lerp( 1.0f, 1.0f - smoothstep( thawRadius * 0.55f, thawRadius, rad ), smoothstep( 0.90f, 1.02f, sec ) );
			float crackEnv      = saturate( baseCrackEnv ) * frostDissolve * thawMask;

			float rayReach = 1.0f - smoothstep( peelFront + 0.18f, peelFront + 0.52f, rad );
			float crackVis = glassCrack * crackEnv * rayReach;

			// Palette: pitch obsidian, cold razor glass-silver, gothic amethyst, crystalline ice-cyan
			float3 obsidian    = lerp( float3( 0.004f, 0.003f, 0.008f ), float3( 0.013f, 0.008f, 0.021f ), nCloud );
			float3 glassSilver = float3( 0.94f, 0.96f, 1.00f );
			float3 amethyst    = float3( 0.62f, 0.28f, 0.94f );
			float3 iceCyan     = float3( 0.70f, 0.88f, 1.00f );

			float slashA = saturate( beat1 * ( slashBlade * 1.00f + slashHalo * 0.44f + slashSub * 0.78f + slashNode ) );
			float3 slashCol = lerp( amethyst, glassSilver, saturate( slashBlade * 0.92f + slashSub * 0.72f + slashNode * 0.80f ) );

			float crackA = saturate( crackVis * 0.86f + preCrack );
			float3 crackCol = lerp( iceCyan, glassSilver, saturate( cr * 0.82f + exp( -rad * 3.2f ) * 0.36f ) );
			crackCol = lerp( crackCol, amethyst, smoothstep( 0.42f, 1.15f, rad ) * 0.30f * ( 1.0f - afterShock * 0.65f ) );

			float rimA = saturate( shardRim * 0.88f + impactCore * 0.96f );
			float3 rimCol = lerp( amethyst, glassSilver, saturate( impactCore * 0.94f + shardRim * 0.62f ) );
			rimCol = lerp( rimCol, iceCyan, afterShock * 0.45f );

			float lightAlpha = saturate( max( slashA, max( crackA, rimA ) ) );
			float wSum = slashA + crackA + rimA + 0.0001f;
			float3 lightCol = saturate( ( slashCol * slashA + crackCol * crackA + rimCol * rimA ) / wSum );

			float tailZero = 1.0f - smoothstep( 0.80f, 0.942f, t );
			float totalAlpha = max( darkMask, lightAlpha );
			float3 fxCol = lerp( obsidian, lightCol, saturate( lightAlpha / ( totalAlpha + 0.0001f ) ) );
			float alpha = saturate( totalAlpha ) * tailZero;

			return float4( saturate( fxCol ), alpha ) * Color;
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
