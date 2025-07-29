vs.1.0
// File: 0d0o0s.vsh.
// This shader takes two projection matrices ( bb and rt )
// note : bb means "the back buffer" and rt means "the render target"
// The first matrix projects the back buffer onto the vertex UV coords.
// The seconds matrix draws the vertex into the render target.

#define CONST_ZERO c0.x
#define CONST_HALF c0.y
#define CONST_ONE  c0.z
#define CONST_TWO  c0.w

#define PROJECT_TO_BB 1
#define PROJECT_TO_RT 5

#define CONST_BB_HALF_WIDTH c9.x
#define CONST_BB_HALF_HEIGHT c9.y
#define CONST_RT_WIDTH c9.z
#define CONST_RT_HEIGHT c9.w

// Transform vertex to back buffer (screen space)
dp4 r1.x, v0, c[ PROJECT_TO_BB ]
dp4 r1.y, v0, c[ PROJECT_TO_BB + 1 ]
dp4 r1.w, v0, c[ PROJECT_TO_BB + 3 ]

// calculate vertex in screen space
rcp r1.w, r1.w
mul r1.xy, r1.xy, r1.w
mad oT0.x, r1.x, CONST_BB_HALF_WIDTH, CONST_BB_HALF_WIDTH
mad oT0.y, -r1.y, CONST_BB_HALF_HEIGHT, CONST_BB_HALF_HEIGHT

// Transform vertex to render target (clip space)
dp4 oPos.x, v0, c[ PROJECT_TO_RT ]
dp4 oPos.y, v0, c[ PROJECT_TO_RT + 1 ]
dp4 oPos.z, v0, c[ PROJECT_TO_RT + 2 ]
dp4 oPos.w, v0, c[ PROJECT_TO_RT + 3 ]

// Output colour as white
mov oD0, c0.zzzz