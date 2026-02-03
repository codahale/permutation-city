//go:build arm64 && !purego

#include "textflag.h"

#define SIMPIRA_STEP(src, dst, zero, inc, t1, t2) \
	EOR R1, R2, R4; \
	VMOV R4, t1.S4; \
	VEOR inc.B16, t1.B16, t1.B16; \
	VORR src.B16, src.B16, t2.B16; \
	AESE zero.B16, t2.B16; \
	AESMC t2.B16, t2.B16; \
	AESE t1.B16, t2.B16; \
	AESMC t2.B16, t2.B16; \
	VEOR t2.B16, dst.B16, dst.B16; \
	ADD $1, R1

#define ROUND512(s0, s1, s2, s3) \
	SIMPIRA_STEP(s0, s1, V6, V7, V4, V5); \
	SIMPIRA_STEP(s2, s3, V6, V7, V4, V5)

// func permute512(state *[64]byte)
TEXT ·permute512(SB), NOSPLIT, $0
	MOVD state+0(FP), R0

	VLD1 (R0), [V0.B16]
	ADD $16, R0, R3
	VLD1 (R3), [V1.B16]
	ADD $16, R3, R3
	VLD1 (R3), [V2.B16]
	ADD $16, R3, R3
	VLD1 (R3), [V3.B16]

	VEOR V6.B16, V6.B16, V6.B16
	VEOR V7.B16, V7.B16, V7.B16
	MOVW $1, R1 // c
	MOVW $4, R2 // b

	MOVD $0x10, R3
	VMOV R3, V7.S[1]
	MOVD $0x20, R3
	VMOV R3, V7.S[2]
	MOVD $0x30, R3
	VMOV R3, V7.S[3]

	MOVW $3, R10 // 3 blocks of 4 rounds
loop4_block:
	ROUND512(V0, V1, V2, V3) // R0
	ROUND512(V1, V2, V3, V0) // R1
	ROUND512(V2, V3, V0, V1) // R2
	ROUND512(V3, V0, V1, V2) // R3

	SUBS $1, R10
	BNE loop4_block

	// Remaining 3 rounds (R12, R13, R14)
	ROUND512(V0, V1, V2, V3) // R12
	ROUND512(V1, V2, V3, V0) // R13
	ROUND512(V2, V3, V0, V1) // R14

	VST1 [V0.B16], (R0)
	ADD $16, R0, R3
	VST1 [V1.B16], (R3)
	ADD $16, R3, R3
	VST1 [V2.B16], (R3)
	ADD $16, R3, R3
	VST1 [V3.B16], (R3)
	RET
