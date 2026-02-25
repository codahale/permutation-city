package keccak //nolint:testpackage // testing internals

import (
	"bytes"
	"crypto/sha3"
	"encoding/hex"
	"testing"
)

func TestP1600(t *testing.T) {
	var state [200]byte
	P1600(&state)

	if got, want := hex.EncodeToString(state[:]), "1786a7b938545e8e1ed059f2506acdd9351fa952c6e7b887c5e0e4cd67e09310455ad9f290ab33b0451adda8722fa7e09c2f6714aa8037c51d075100f547dd3ecc8a170c311da3b3a0aa5792a586b5799bf9b1b33d7c4abc93678ae66340876866250e2e33036c5cda30f0b90212aa9c9f7acf2b789a3b5f2379ae61e0c136e5ec873cb718b6e96dc28a9170f1d1be2ab724edda53bdab6a5ae12e2c6a41c1bfaf5209b936e0cfc6d76070dc17365045e47a9fc2b21156627a64302cdb7136d41ca02c22760dfdcf"; got != want {
		t.Errorf("P1600(0*200) = %s, want = %s", got, want)
	}
}

func TestF1600(t *testing.T) {
	var state [200]byte
	F1600(&state)

	if got, want := hex.EncodeToString(state[:]), "e7dde140798f25f18a47c033f9ccd584eea95aa61e2698d54d49806f304715bd57d05362054e288bd46f8e7f2da497ffc44746a4a0e5fe90762e19d60cda5b8c9c05191bf7a630ad64fc8fd0b75a933035d617233fa95aeb0321710d26e6a6a95f55cfdb167ca58126c84703cd31b8439f56a5111a2ff20161aed9215a63e505f270c98cf2febe641166c47b95703661cb0ed04f555a7cb8c832cf1c8ae83e8c14263aae22790c94e409c5a224f94118c26504e72635f5163ba1307fe944f67549a2ec5c7bfff1ea"; got != want {
		t.Errorf("F1600(0*200) = %s, want = %s", got, want)
	}
}

func TestF1600Generic(t *testing.T) {
	t.Run("12 rounds", func(t *testing.T) {
		var state [200]byte
		f1600Generic(&state, 12)

		if got, want := hex.EncodeToString(state[:]), "1786a7b938545e8e1ed059f2506acdd9351fa952c6e7b887c5e0e4cd67e09310455ad9f290ab33b0451adda8722fa7e09c2f6714aa8037c51d075100f547dd3ecc8a170c311da3b3a0aa5792a586b5799bf9b1b33d7c4abc93678ae66340876866250e2e33036c5cda30f0b90212aa9c9f7acf2b789a3b5f2379ae61e0c136e5ec873cb718b6e96dc28a9170f1d1be2ab724edda53bdab6a5ae12e2c6a41c1bfaf5209b936e0cfc6d76070dc17365045e47a9fc2b21156627a64302cdb7136d41ca02c22760dfdcf"; got != want {
			t.Errorf("P1600(0*200) = %s, want = %s", got, want)
		}
	})

	t.Run("24 rounds", func(t *testing.T) {
		var state [200]byte
		f1600Generic(&state, 24)

		if got, want := hex.EncodeToString(state[:]), "e7dde140798f25f18a47c033f9ccd584eea95aa61e2698d54d49806f304715bd57d05362054e288bd46f8e7f2da497ffc44746a4a0e5fe90762e19d60cda5b8c9c05191bf7a630ad64fc8fd0b75a933035d617233fa95aeb0321710d26e6a6a95f55cfdb167ca58126c84703cd31b8439f56a5111a2ff20161aed9215a63e505f270c98cf2febe641166c47b95703661cb0ed04f555a7cb8c832cf1c8ae83e8c14263aae22790c94e409c5a224f94118c26504e72635f5163ba1307fe944f67549a2ec5c7bfff1ea"; got != want {
			t.Errorf("F1600(0*200) = %s, want = %s", got, want)
		}
	})
}

func FuzzF1600(f *testing.F) {
	drbg := sha3.NewSHAKE128()
	_, _ = drbg.Write([]byte("Keccak-f[1600]"))
	for range 10 {
		var state [200]byte
		_, _ = drbg.Read(state[:])
		f.Add(state[:])
	}

	f.Fuzz(func(t *testing.T, data []byte) {
		if len(data) != 200 {
			t.Skip()
		}

		var state1, state2 [200]byte
		copy(state1[:], data)
		copy(state2[:], data)

		F1600(&state1)            // Should use ASM
		f1600Generic(&state2, 24) // Reference

		if !bytes.Equal(state1[:], state2[:]) {
			t.Errorf("Keccak-f[1600](%x) = %x, want = %x", data, state1, state2)
		}
	})
}

func TestP1600x2(t *testing.T) {
	// Two zero states should both match the known P1600 test vector.
	var state [400]byte
	P1600x2(&state)

	want := "1786a7b938545e8e1ed059f2506acdd9351fa952c6e7b887c5e0e4cd67e09310455ad9f290ab33b0451adda8722fa7e09c2f6714aa8037c51d075100f547dd3ecc8a170c311da3b3a0aa5792a586b5799bf9b1b33d7c4abc93678ae66340876866250e2e33036c5cda30f0b90212aa9c9f7acf2b789a3b5f2379ae61e0c136e5ec873cb718b6e96dc28a9170f1d1be2ab724edda53bdab6a5ae12e2c6a41c1bfaf5209b936e0cfc6d76070dc17365045e47a9fc2b21156627a64302cdb7136d41ca02c22760dfdcf"
	if got := hex.EncodeToString(state[:200]); got != want {
		t.Errorf("P1600x2 state1(0*200) = %s, want = %s", got, want)
	}
	if got := hex.EncodeToString(state[200:]); got != want {
		t.Errorf("P1600x2 state2(0*200) = %s, want = %s", got, want)
	}

	// Two different states should each match sequential P1600 results.
	drbg := sha3.NewSHAKE128()
	_, _ = drbg.Write([]byte("P1600x2-test"))

	var aRef, bRef [200]byte
	_, _ = drbg.Read(state[:200])
	_, _ = drbg.Read(state[200:])
	copy(aRef[:], state[:200])
	copy(bRef[:], state[200:])

	P1600x2(&state)
	f1600Generic(&aRef, 12)
	f1600Generic(&bRef, 12)

	if !bytes.Equal(state[:200], aRef[:]) {
		t.Errorf("P1600x2 state1 mismatch: got %x, want %x", state[:200], aRef)
	}
	if !bytes.Equal(state[200:], bRef[:]) {
		t.Errorf("P1600x2 state2 mismatch: got %x, want %x", state[200:], bRef)
	}
}

func FuzzP1600(f *testing.F) {
	drbg := sha3.NewSHAKE128()
	_, _ = drbg.Write([]byte("Keccak-p[1600,12]"))
	for range 10 {
		var state [200]byte
		_, _ = drbg.Read(state[:])
		f.Add(state[:])
	}

	f.Fuzz(func(t *testing.T, data []byte) {
		if len(data) != 200 {
			t.Skip()
		}

		var state1, state2 [200]byte
		copy(state1[:], data)
		copy(state2[:], data)

		P1600(&state1)            // Should use ASM
		f1600Generic(&state2, 12) // Reference

		if !bytes.Equal(state1[:], state2[:]) {
			t.Errorf("Keccak-p[1600,12](%x) = %x, want = %x", data, state1, state2)
		}
	})
}

func FuzzP1600x2(f *testing.F) {
	drbg := sha3.NewSHAKE128()
	_, _ = drbg.Write([]byte("Keccak-p[1600,12]x2"))
	for range 10 {
		var seed [400]byte
		_, _ = drbg.Read(seed[:])
		f.Add(seed[:])
	}

	f.Fuzz(func(t *testing.T, data []byte) {
		if len(data) != 400 {
			t.Skip()
		}

		var state [400]byte
		var ref1, ref2 [200]byte
		copy(state[:], data)
		copy(ref1[:], state[:200])
		copy(ref2[:], state[200:])

		P1600x2(&state)
		f1600Generic(&ref1, 12)
		f1600Generic(&ref2, 12)

		if !bytes.Equal(state[:200], ref1[:]) {
			t.Errorf("P1600x2 state1(%x) = %x, want = %x", data[:200], state[:200], ref1)
		}
		if !bytes.Equal(state[200:], ref2[:]) {
			t.Errorf("P1600x2 state2(%x) = %x, want = %x", data[200:], state[200:], ref2)
		}
	})
}
