//go:build arm64 && !purego

#include "textflag.h"

#define SIMPIRA_STEP(src, dst, zero, inc, t1, t2) \
	EOR R1, R2, R4; \
	VMOV R4, t1.S4; \
	VEOR inc.B16, t1.B16, t1.B16; \
	VORR src.B16, src.B16, t2.B16; \
	AESE zero.B16, t2.B16; \
	AESMC t2.B16, t2.B16; \
	VEOR t1.B16, t2.B16, t2.B16; \
	AESE zero.B16, t2.B16; \
	AESMC t2.B16, t2.B16; \
	VEOR t2.B16, dst.B16, dst.B16; \
	ADD $1, R1

// func permute256(state *[32]byte)
TEXT ·permute256(SB), NOSPLIT, $0
	MOVD state+0(FP), R0

	VLD1 (R0), [V0.B16]
	ADD $16, R0, R3
	VLD1 (R3), [V1.B16]

	VEOR V6.B16, V6.B16, V6.B16 // zero
	VEOR V7.B16, V7.B16, V7.B16 // increment constant

	MOVW $1, R1 // c
	MOVW $2, R2 // b

	// Preload increment constant
	MOVD $0x10, R3
	VMOV R3, V7.S[1]
	MOVD $0x20, R3
	VMOV R3, V7.S[2]
	MOVD $0x30, R3
	VMOV R3, V7.S[3]

	MOVW $7, R10 // 7 pairs

loop2:
	// Round r (even): x1 ^= F(x0)
	SIMPIRA_STEP(V0, V1, V6, V7, V4, V5)

	// Round r+1 (odd): x0 ^= F(x1)
	SIMPIRA_STEP(V1, V0, V6, V7, V4, V5)

	SUBS $1, R10
	BNE loop2

	// Round 14: x1 ^= F(x0)
	SIMPIRA_STEP(V0, V1, V6, V7, V4, V5)

	VST1 [V0.B16], (R0)
	ADD $16, R0, R3
	VST1 [V1.B16], (R3)
	RET
