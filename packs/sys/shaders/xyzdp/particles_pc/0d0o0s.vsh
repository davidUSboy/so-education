vs.1.1

// File: point_sprite.vsh
#define CONST_ZERO c0.x
#define CONST_HALF c0.y
#define CONST_ONE  c0.z
#define CONST_TWO  c0.w

#define PROJ	1
#define FOG		c5
#define HALF_HEIGHT	c6

dcl_position v0
dcl_color v1
dcl_psize v2

// Transform position
dp4 oPos.x, v0, c[ PROJ]
dp4 oPos.y, v0, c[ PROJ+ 1 ]
dp4 oPos.z, v0, c[ PROJ+ 2 ]

// Fog and w component
dp4 r0.x, v0, c[ PROJ+ 3 ]
mov oPos.w, r0.x
mad oFog, r0.x, FOG.x, FOG.y
mov oD0, v1


//r1.x is 1/w
rcp r1.x, r0.x
//r2.x is size * screen
mul r2.x, v2, c6.x
//oPts is size * screen * 1/w
mul oPts, r2.x, r1.x