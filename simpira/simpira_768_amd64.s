//go:build amd64 && !purego

#include "textflag.h"

// func permute768(state *[96]byte)
TEXT ·permute768(SB), NOSPLIT, $0
	MOVQ state+0(FP), DI

	MOVOU 0(DI), X0   // x0
	MOVOU 16(DI), X1  // x1
	MOVOU 32(DI), X2  // x2
	MOVOU 48(DI), X3  // x3
	MOVOU 64(DI), X4  // x4
	MOVOU 80(DI), X5  // x5

	MOVL $1, AX       // c = 1
	MOVL $6, BX       // b = 6

	// ROUND_6_STEP: s0..s5 are registers mapped to s[r]..s[r+5]
	// Op 1: s0 -> s1
	// Op 2: s2 -> s5
	// Op 3: s4 -> s3
#define ROUND_6_STEP(s0, s1, s2, s3, s4, s5) \
	/* Consts */ \
	MOVL AX, DX; XORL BX, DX; MOVD DX, X6; PSHUFD $0, X6, X6; PXOR ·constInc(SB), X6; INCL AX; \
	MOVL AX, DX; XORL BX, DX; MOVD DX, X7; PSHUFD $0, X7, X7; PXOR ·constInc(SB), X7; INCL AX; \
	MOVL AX, DX; XORL BX, DX; MOVD DX, X8; PSHUFD $0, X8, X8; PXOR ·constInc(SB), X8; INCL AX; \
	/* AES 1 */ \
	MOVOU s0, X9;  AESENC X6, X9; \
	MOVOU s2, X10; AESENC X7, X10; \
	MOVOU s4, X11; AESENC X8, X11; \
	/* AES 2 + Mix */ \
	AESENC s1, X9;  MOVOU X9, s1; \
	AESENC s5, X10; MOVOU X10, s5; \
	AESENC s3, X11; MOVOU X11, s3

	// Reg mapping:
	// REG[0]=X0, REG[1]=X1, REG[2]=X2, REG[3]=X5, REG[4]=X4, REG[5]=X3

	// Unroll 15 rounds
	ROUND_6_STEP(X0, X1, X2, X5, X4, X3) // Round 0
	ROUND_6_STEP(X1, X2, X5, X4, X3, X0) // Round 1
	ROUND_6_STEP(X2, X5, X4, X3, X0, X1) // Round 2
	ROUND_6_STEP(X5, X4, X3, X0, X1, X2) // Round 3
	ROUND_6_STEP(X4, X3, X0, X1, X2, X5) // Round 4
	ROUND_6_STEP(X3, X0, X1, X2, X5, X4) // Round 5

	ROUND_6_STEP(X0, X1, X2, X5, X4, X3) // Round 6
	ROUND_6_STEP(X1, X2, X5, X4, X3, X0) // Round 7
	ROUND_6_STEP(X2, X5, X4, X3, X0, X1) // Round 8
	ROUND_6_STEP(X5, X4, X3, X0, X1, X2) // Round 9
	ROUND_6_STEP(X4, X3, X0, X1, X2, X5) // Round 10
	ROUND_6_STEP(X3, X0, X1, X2, X5, X4) // Round 11

	ROUND_6_STEP(X0, X1, X2, X5, X4, X3) // Round 12
	ROUND_6_STEP(X1, X2, X5, X4, X3, X0) // Round 13
	ROUND_6_STEP(X2, X5, X4, X3, X0, X1) // Round 14

	MOVOU X0, 0(DI)
	MOVOU X1, 16(DI)
	MOVOU X2, 32(DI)
	MOVOU X3, 48(DI)
	MOVOU X4, 64(DI)
	MOVOU X5, 80(DI)
	RET

GLOBL ·constInc(SB), (NOPTR+RODATA), $16
DATA ·constInc+0(SB)/4, $0x00
DATA ·constInc+4(SB)/4, $0x10
DATA ·constInc+8(SB)/4, $0x20
DATA ·constInc+12(SB)/4, $0x30
