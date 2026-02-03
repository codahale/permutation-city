//go:build amd64 && !purego

#include "textflag.h"

// func permute256(state *[32]byte)
TEXT ·permute256(SB), NOSPLIT, $0
	MOVQ state+0(FP), DI

	MOVOU 0(DI), X0   // x0
	MOVOU 16(DI), X1  // x1

	PXOR X6, X6       // zero

	MOVL $1, AX       // c = 1
	MOVL $2, BX       // b = 2

	MOVQ $7, CX      // 7 pairs of rounds = 14 rounds

loop2_unrolled:
	// Round r (even): x1 ^= F(x0)
	MOVL AX, DX
	XORL BX, DX
	MOVD DX, X4
	PSHUFD $0, X4, X4
	PXOR ·constInc(SB), X4
	MOVOU X0, X5
	AESENC X4, X5
	AESENC X6, X5
	PXOR X5, X1
	INCL AX

	// Round r+1 (odd): x0 ^= F(x1)
	MOVL AX, DX
	XORL BX, DX
	MOVD DX, X4
	PSHUFD $0, X4, X4
	PXOR ·constInc(SB), X4
	MOVOU X1, X5
	AESENC X4, X5
	AESENC X6, X5
	PXOR X5, X0
	INCL AX

	LOOP loop2_unrolled

	// Round 14 (last): x1 ^= F(x0)
	MOVL AX, DX
	XORL BX, DX
	MOVD DX, X4
	PSHUFD $0, X4, X4
	PXOR ·constInc(SB), X4
	MOVOU X0, X5
	AESENC X4, X5
	AESENC X6, X5
	PXOR X5, X1

	MOVOU X0, 0(DI)
	MOVOU X1, 16(DI)
	RET

