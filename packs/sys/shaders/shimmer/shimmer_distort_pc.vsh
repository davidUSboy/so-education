vs.1.1

// File: 0d0o0s.vsh.	(The heat shimmer shader for PC)
// This shader takes a full-screen mesh with vertices in clip space.
// Two sets of uvs are output, one being the standard uvs, the other
// begin heat-shimmer perturbed uvs ( done in this shader )

#define CONST_ZERO c0.x
#define CONST_HALF c0.y
#define CONST_ONE  c0.z
#define CONST_TWO  c0.w

#define CONST_SCREEN_FACTOR c9.xy
#define CONST_SCREEN_OFFSET c9.zw

#define CONST_ANIMATION_SPREAD c10.xy
#define CONST_ANIMATION_T c10.zzzz
#define CONST_TWO_PI c10.wwww

#define CONST_TIME_OFFSET  c11
#define SIN_VEC				c12
#define COS_VEC				c13
#define CONST_NOISE_FREQ_S	c14
#define CONST_NOISE_FREQ_T	c15
#define CONST_WAVE_SPEED	c16
#define CONST_FIXUP			c17

#define LOCAL_CAMERA_POS	c18
#define UV_FIXUP		c19
#define WHOLE_SCREEN_ALPHA	c19.zzzz

dcl_position v0
dcl_normal   v1
dcl_texcoord v2

// Transform vertex to render target (screen space)
add oPos.xy, v0.xy, CONST_SCREEN_OFFSET
mov oPos.zw, c0.zz

// Set UV 0 to be standard tex coordinates ( unperturbed )
mov oT0.xy, v2.xy
mov oT0.zw, c0.xz
mov r11.xy, v2.xy

// Output colour as passed in alpha
// This is for full-screen effects ( like when you
// are inside a shockwave )
mov oD0.xyzw, WHOLE_SCREEN_ALPHA

// Animate the uv.
mul r0, CONST_NOISE_FREQ_S, r11.x
mad r0, CONST_NOISE_FREQ_T, r11.y, r0

mov r1, CONST_ANIMATION_T
mad r0, r1, CONST_WAVE_SPEED, r0
frc r0.xy, r0
frc r1.xy, r0.zwzw
mov r0.zw, r1.xyxy
mul r0, r0, CONST_FIXUP.x
sub r0, r0, CONST_HALF
mul r1, r0, CONST_TWO_PI

mul r2, r1, r1
mul r3, r2, r1
mul r5, r3, r2
mul r7, r5, r2
mul r9, r7, r2

mad r0, r3, SIN_VEC.x, r1
mad r0, r5, SIN_VEC.y, r0
mad r0, r7, SIN_VEC.z, r0
mad r0, r9, SIN_VEC.w, r0

// And output uv.  scale results by the spread of the effect.
mad r11.xy, CONST_ANIMATION_SPREAD, r0.xy, r11.xy
add oT1.xy, r11.xy, UV_FIXUP.xy
