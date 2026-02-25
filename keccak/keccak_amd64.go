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
func p1600x4AVX512(a, b, c, d *[200]byte)

func p1600x2(a, b *[200]byte) {
	if cpu.X86.HasAVX512F && cpu.X86.HasAVX512VL {
		p1600x2AVX512(a, b)
	} else {
		f1600Generic(a, 12)
		f1600Generic(b, 12)
	}
}

func p1600x4(a, b, c, d *[200]byte) {
	if cpu.X86.HasAVX512F && cpu.X86.HasAVX512VL {
		p1600x4AVX512(a, b, c, d)
	} else {
		f1600Generic(a, 12)
		f1600Generic(b, 12)
		f1600Generic(c, 12)
		f1600Generic(d, 12)
	}
}
