// Copyright 2024 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build (!amd64 && !arm64) || purego

package keccak

func f1600(a *[200]byte) {
	f1600Generic(a, 24)
}

func p1600(a *[200]byte) {
	f1600Generic(a, 12)
}

func P1600x2(state1, state2 *[200]byte) {
	f1600Generic(state1, 12)
	f1600Generic(state2, 12)
}

func P1600x4(state1, state2, state3, state4 *[200]byte) {
	f1600Generic(state1, 12)
	f1600Generic(state2, 12)
	f1600Generic(state3, 12)
	f1600Generic(state4, 12)
}
