# Permutation City

This repo contains implementations of the following permutations with full optimization for both `amd64` and `arm64`
architectures:

* Areion-512
* Ascon-8
* Ascon-12
* Gimli-384
* Haraka-512 V2
* Keccak-f\[1600\]
* Keccak-p\[1600, 12\]
* Simpira-256 V2
* Simpira-512 V2
* Simpira-768 V2
* Simpira-1024 V2
* Xoodoo

## ⚠️ Security Warning

**This code has not been audited.** It is experimental and should not be used for production systems or critical
security applications. Use at your own risk.

## Performance

### arm64

```text
goos: darwin                                                                                                                                                                                                                                         
goarch: arm64
pkg: github.com/codahale/permutation-city
cpu: Apple M4 Pro
BenchmarkAreion512-14           271043318               21.95 ns/op     2915.82 MB/s           0 B/op          0 allocs/op
BenchmarkAscon12-14             223411255               26.85 ns/op     1489.95 MB/s           0 B/op          0 allocs/op
BenchmarkAscon8-14              324286826               18.48 ns/op     2164.12 MB/s           0 B/op          0 allocs/op
BenchmarkGimli384-14            85662225                68.28 ns/op      702.96 MB/s           0 B/op          0 allocs/op
BenchmarkHaraka512-14           255149623               23.58 ns/op     2713.60 MB/s           0 B/op          0 allocs/op
BenchmarkKeccakF1600-14         51540948               115.9 ns/op      1725.70 MB/s           0 B/op          0 allocs/op
BenchmarkKeccakP1600-14         99095204                59.65 ns/op     3352.89 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira256-14          174793746               34.35 ns/op      931.66 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira512-14          173078990               34.58 ns/op     1850.67 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira768-14          172720959               34.72 ns/op     2765.11 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira1024-14         137034960               43.77 ns/op     2924.63 MB/s           0 B/op          0 allocs/op
BenchmarkXoodoo-14              170471202               35.19 ns/op     1364.06 MB/s           0 B/op          0 allocs/op
```

### amd64

```text
goos: linux
goarch: amd64
pkg: github.com/codahale/permutation-city
cpu: INTEL(R) XEON(R) PLATINUM 8581C CPU @ 2.30GHz
BenchmarkAreion512-4            52033068                22.97 ns/op     2786.78 MB/s           0 B/op          0 allocs/op
BenchmarkAscon12-4              19412529                61.71 ns/op      648.20 MB/s           0 B/op          0 allocs/op
BenchmarkAscon8-4               26767323                44.92 ns/op      890.44 MB/s           0 B/op          0 allocs/op
BenchmarkGimli384-4             14779448                81.16 ns/op      591.44 MB/s           0 B/op          0 allocs/op
BenchmarkHaraka512-4            38345859                31.27 ns/op     2046.63 MB/s           0 B/op          0 allocs/op
BenchmarkKeccakF1600-4           3490239               344.0 ns/op       581.39 MB/s           0 B/op          0 allocs/op
BenchmarkKeccakP1600-4           6985438               172.2 ns/op      1161.30 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira256-4           28108608                42.56 ns/op      751.85 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira512-4           27781494                43.01 ns/op     1488.03 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira768-4           27188736                44.16 ns/op     2173.69 MB/s           0 B/op          0 allocs/op
BenchmarkSimpira1024-4          20686183                57.99 ns/op     2207.26 MB/s           0 B/op          0 allocs/op
BenchmarkXoodoo-4               11924196               100.9 ns/op       475.85 MB/s           0 B/op          0 allocs/op
```

## License

MIT or Apache 2.0.