vs.1.1

#define WORLD_VIEW_PROJECTION_MATRIX 1

#define FOG c15

dcl_position v0
dcl_color0 v1
dcl_color1 v2
dcl_texcoord v3

//------------------------------------------------
//		Transform position
//------------------------------------------------
dp4 oPos.x, v0, c[ WORLD_VIEW_PROJECTION_MATRIX ]
dp4 oPos.y, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 1 ]

// Fog and w (and z) component
dp4 r0.x, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 3 ]
mov oPos.zw, r0.x
mad oFog, r0.x, FOG.x, FOG.y

mov oD0, v1
mov oD1, v2
mov oT0.xy, v3

//dp4 r1, v0, c[ WORLD_VIEW_PROJECTION_MATRIX + 2 ]
//mov oD0.w, r1.z
