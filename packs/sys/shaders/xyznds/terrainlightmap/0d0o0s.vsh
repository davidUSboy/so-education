vs.1.1

//Inputs
//c0 = numeric constants
//c1 = ambient light
//c2 = directional light
//c4 = 1 / (sun penundrum)
//c5 = sun angle (0....1)
//c32 = world view projection matrix
//c36 2d texture matrix.
//v0 = position
//v1 = normal
//v2 = colour blends 	( .x =  {0.5 .... 1.0 }
//			  .y =  {0.5 .... 1.0 }
//			  .z =  {0.5 .... 1.0 }	
//			  .w =  {0.0 .... 1.0 } )
//v3 = sun angle.
//
//Outputs
//oPos
//oD0.xyz = diffuse + ambient lighting 

dcl_position v0
dcl_normal v1
dcl_color0 v2
dcl_color1 v3

#define CONST_ZERO c0.x
#define CONST_HALF c0.y
#define CONST_ONE  c0.z
#define CONST_TWO  c0.w

#define FOG c31

//#include "lighting.h"

#define WORLD_VIEW_PROJECTION_MATRIX 32

// Transform position
dp4 oPos.x, v0, c[ WORLD_VIEW_PROJECTION_MATRIX ]
dp4 oPos.y, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 1 ]
dp4 oPos.z, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 2 ]
dp4 r0.x, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 3 ]
mov oPos.w, r0.x
mad oFog, r0.x, FOG.x, FOG.y

// Do lighting
//mov r0, CONST_ZERO
dp3 r0, v1, c2
min r0, r0, CONST_ONE
max r0, r0, CONST_ZERO
mul r0, r0, c3

//DirectionalLight r0, v1, 2

sub r1, c5, v3
mul r1, r1, c4
mov r1.y, -r1.y

min r1, r1, CONST_ONE
max r1, r1, CONST_ZERO
mul r1, r1.x, r1.y
mad oD0, r0, r1, c1