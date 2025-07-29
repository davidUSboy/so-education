vs.1.1
// File: 0d0o0s.vsh.	(The shield shader.)
// This shader takes two projection matrices ( bb and rt )
// note : bb means "the back buffer" and rt means "the render target"
// The first matrix projects the back buffer onto the vertex UV coords.
// The seconds matrix draws the vertex into the render target.

#define CONST_ZERO c0.x
#define CONST_HALF c0.y
#define CONST_ONE  c0.z
#define CONST_TWO_PI  c0.w

#define PROJECT_TO_BB 1
#define PROJECT_TO_RT 5

#define CONST_RT_SCALE_X c9.x
#define CONST_RT_SCALE_Y c9.y
#define CONST_RT_BIAS_X c9.z
#define CONST_RT_BIAS_Y c9.w

#define CONST_ANIMATION_T c10.x
#define CONST_ANIMATION_SPREAD c10.y
#define HALF_PI c10.w

#define CONST_TIME_OFFSET  c11
#define SIN_VEC				c12
#define COS_VEC				c13
#define CONST_NOISE_FREQ_S	c14
#define CONST_NOISE_FREQ_T	c15
#define CONST_WAVE_SPEED	c16
#define CONST_FIXUP			c17
#define LOCAL_CAMERA_POS	c18


dcl_position v0
dcl_normal   v1
dcl_texcoord v2

// Transform vertex to render target (screen space)
dp4 r1.x, v0, c[ PROJECT_TO_RT ]
dp4 r1.y, v0, c[ PROJECT_TO_RT + 1 ]
dp4 r1.w, v0, c[ PROJECT_TO_RT + 3 ]

// calculate vertex in texture space
rcp r1.w, r1.w
mul r1.xy, r1.xy, r1.w
mad r3.xy, r1.xy, c9.xy, c9.zw

// Animate the uv.

//calculate taylor series inputs
mul r0, CONST_NOISE_FREQ_S, r3.x
mad r0, CONST_NOISE_FREQ_T, r3.y, r0
mov r1, CONST_ANIMATION_T
mad r0, r1, CONST_WAVE_SPEED, r0
add r0, r0, CONST_TIME_OFFSET

//modulo to the appropriate range.
frc r0.xy, r0
frc r1.xy, r0.zwzw
mov r0.zw, r1.xyxy
mul r0.x, r0.x, CONST_FIXUP.x
sub r0.x, r0.x, CONST_HALF
mul r0.x, r0.x, CONST_TWO_PI

//calculate taylor series expansion
mul r1.x, r0.x, r0.x
mul r2.y, r1.x, r0.x
mul r1.y, r2.y, r0.x
mul r2.z, r1.y, r0.x
mul r1.z, r2.z, r0.x
mul r2.w, r1.z, r0.x
mul r1.w, r2.w, r0.x

mad r2.x, r2.y, SIN_VEC.y, r0.x
mad r2.x, r2.z, SIN_VEC.z, r2.x
mad r2.x, r2.w, SIN_VEC.w, r2.x

mov r0.x, CONST_ONE
mad r1.x, r1.x, COS_VEC.x, r0.x
mad r1.x, r1.y, COS_VEC.y, r1.x
mad r1.x, r1.z, COS_VEC.z, r1.x
mad r2.y, r1.w, COS_VEC.w, r1.x

//so r2.xy has sin(t) and cos(t)
//where t has been modified by the frequencies etc.

//sin and cos should be centered around 0, not pi
add r2.xy, r2.xy, CONST_ONE

// And output uv.  scale results by the spread of the effect.
mov oT0.xy, v2
mad oT1.xy, CONST_ANIMATION_SPREAD, r2.xy, r3.xy

// Transform vertex to render target (clip space)
dp4 oPos.x, v0, c[ PROJECT_TO_BB ]
dp4 oPos.y, v0, c[ PROJECT_TO_BB + 1 ]
dp4 oPos.z, v0, c[ PROJECT_TO_BB + 2 ]
dp4 oPos.w, v0, c[ PROJECT_TO_BB + 3 ]


// Calculate alpha ( fade off when facing away from camera )
dp3 r0.w, c18.xyz, v0.xyz
sub r0.w, CONST_ONE, r0.w
mul oD0.w, r0.w, r0.w


// Output colour as white
mov oD0.xyz, c0.zzz