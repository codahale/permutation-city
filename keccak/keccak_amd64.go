// Copyright 2015 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build !purego

package keccak

import "golang.org/x/sys/cpu"

//go:noescape
//goland:noinspection GoUnusedParameter
func f1600(a *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600(a *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600x2AVX512(a, b *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600x2SSE2(a, b *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600x4AVX512(a, b, c, d *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600x4AVX2(a, b, c, d *[200]byte)

func P1600x2(state1, state2 *[200]byte) {
	if cpu.X86.HasAVX512F && cpu.X86.HasAVX512VL {
		p1600x2AVX512(state1, state2)
	} else {
		p1600x2SSE2(state1, state2)
	}
}

func P1600x4(state1, state2, state3, state4 *[200]byte) {
	if cpu.X86.HasAVX512F && cpu.X86.HasAVX512VL {
		p1600x4AVX512(state1, state2, state3, state4)
	} else if cpu.X86.HasAVX2 {
		p1600x4AVX2(state1, state2, state3, state4)
	} else {
		p1600x2SSE2(state1, state2)
		p1600x2SSE2(state3, state4)
	}
}

func init() {
	if cpu.X86.HasAVX512F && cpu.X86.HasAVX512VL {
		Lanes = 4
	}
	Lanes = 2
}
