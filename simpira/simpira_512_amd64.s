//go:build amd64 && !purego

#include "textflag.h"

// func permute512(state *[64]byte)
TEXT ·permute512(SB), NOSPLIT, $0
	MOVQ state+0(FP), DI

	MOVOU 0(DI), X0   // x0
	MOVOU 16(DI), X1  // x1
	MOVOU 32(DI), X2  // x2
	MOVOU 48(DI), X3  // x3

	PXOR X6, X6       // zero
	MOVL $1, AX       // c = 1
	MOVL $4, BX       // b = 4

	// Unroll 15 rounds

#define ROUND(r0, r1, r2, r3) \
	MOVL AX, DX; \
	XORL BX, DX; \
	MOVD DX, X4; \
	PSHUFD $0, X4, X4; \
	PXOR ·constInc(SB), X4; \
	MOVOU r0, X5; \
	AESENC X4, X5; \
	AESENC X6, X5; \
	PXOR X5, r1; \
	INCL AX; \
	MOVL AX, DX; \
	XORL BX, DX; \
	MOVD DX, X4; \
	PSHUFD $0, X4, X4; \
	PXOR ·constInc(SB), X4; \
	MOVOU r2, X5; \
	AESENC X4, X5; \
	AESENC X6, X5; \
	PXOR X5, r3; \
	INCL AX;

	ROUND(X0, X1, X2, X3) // Round 0
	ROUND(X1, X2, X3, X0) // Round 1
	ROUND(X2, X3, X0, X1) // Round 2
	ROUND(X3, X0, X1, X2) // Round 3
	ROUND(X0, X1, X2, X3) // Round 4
	ROUND(X1, X2, X3, X0) // Round 5
	ROUND(X2, X3, X0, X1) // Round 6
	ROUND(X3, X0, X1, X2) // Round 7
	ROUND(X0, X1, X2, X3) // Round 8
	ROUND(X1, X2, X3, X0) // Round 9
	ROUND(X2, X3, X0, X1) // Round 10
	ROUND(X3, X0, X1, X2) // Round 11
	ROUND(X0, X1, X2, X3) // Round 12
	ROUND(X1, X2, X3, X0) // Round 13
	ROUND(X2, X3, X0, X1) // Round 14

	MOVOU X0, 0(DI)
	MOVOU X1, 16(DI)
	MOVOU X2, 32(DI)
	MOVOU X3, 48(DI)
	RET
