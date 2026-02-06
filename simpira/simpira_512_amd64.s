//go:build amd64 && !purego

#include "textflag.h"

// func permute512(state *[64]byte)
TEXT ·permute512(SB), NOSPLIT, $0
	MOVQ state+0(FP), DI

	MOVOU 0(DI), X0   // x0
	MOVOU 16(DI), X1  // x1
	MOVOU 32(DI), X2  // x2
	MOVOU 48(DI), X3  // x3

	MOVL $1, AX       // c = 1
	MOVL $4, BX       // b = 4

	// Unroll 15 rounds

#define ROUND(r0, r1, r2, r3) \
	/* Chain 1 Const */ \
	MOVL AX, DX; \
	XORL BX, DX; \
	MOVD DX, X4; \
	PSHUFD $0, X4, X4; \
	PXOR ·constInc(SB), X4; \
	INCL AX; \
	/* Chain 2 Const */ \
	MOVL AX, DX; \
	XORL BX, DX; \
	MOVD DX, X5; \
	PSHUFD $0, X5, X5; \
	PXOR ·constInc(SB), X5; \
	INCL AX; \
	/* Chain 1 AES 1 */ \
	MOVOU r0, X6; \
	AESENC X4, X6; \
	/* Chain 2 AES 1 */ \
	MOVOU r2, X7; \
	AESENC X5, X7; \
	/* Chain 1 AES 2 + Mix */ \
	AESENC r1, X6; \
	MOVOU X6, r1; \
	/* Chain 2 AES 2 + Mix */ \
	AESENC r3, X7; \
	MOVOU X7, r3

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
