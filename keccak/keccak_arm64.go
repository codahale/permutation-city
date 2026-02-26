// Copyright 2025 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build !purego

package keccak

//go:noescape
//goland:noinspection GoUnusedParameter
func f1600(a *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600(a *[200]byte)

//go:noescape
//goland:noinspection GoUnusedParameter
func p1600x2(a, b *[200]byte)

func P1600x2(state1, state2 *[200]byte) {
	p1600x2(state1, state2)
}

func P1600x4(state1, state2, state3, state4 *[200]byte) {
	p1600x2(state1, state2)
	p1600x2(state3, state4)
}

func init() {
	Lanes = 2
}
