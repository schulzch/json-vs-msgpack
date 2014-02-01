# JSON vs. msgpack (node.js)

This is a quick benchmark of JSON vs. msgpack (de-)serialization. Various msgpack implementations were used (see package.json). 

# Benchmark

The objects generated for benchmarking are forced into dictionary mode and contain a mix of numbers and strings. The benchmark itself is a simple encoding-decoding roundtrip.

# Results

If you're lazy have fun with some random results obtained on Windows 7 x64 using node.js v0.10.24:

## Small object, 10000 cycles

Name | Time | % | Size | % | Gzip Size | %
--- | --- | --- | --- | --- | --- | ---
JSON | 31ms | 100% | 70 bytes | 100% | 70 bytes | 100%
msgpack | 124ms | 400% | 38 bytes | 54% | 44 bytes | 63%
msgpackJS | 374ms | 1206% | 38 bytes | 54% | 44 bytes | 63%
msgpackJS5 | 373ms | 1203% | 38 bytes | 54% | 44 bytes | 63%
purepack | 371ms | 1197% | 38 bytes | 54% | 44 bytes | 63%

## Large object, 10 cycles

Name | Time | % | Size | % | Gzip Size | %
--- | --- | --- | --- | --- | --- | ---
JSON | 61ms | 100% | 484269 bytes | 100% | 235938 bytes | 100%
msgpack | 40ms | 66% | 332809 bytes | 69% | 203781 bytes | 86%
msgpackJS | 315ms | 516% | 332809 bytes | 69% | 203781 bytes | 86%
msgpackJS5 | 348ms | 570% | 332809 bytes | 69% | 203781 bytes | 86%
purepack | 313ms | 513% | 332809 bytes | 69% | 203781 bytes | 86%

## Worth mentioning

- JSON will hurt floating point precision
- msgpack is more space efficient
- V8's JSON parsing and formatting is optimized, **a lot**
- JavaScript msgpack implementations are slow (even when using typed arrays, asm.js might be worth a try)
- node-msgpack seems to do something wrong (compare many calls vs. large object, might be an allocation strategy problem)
- compressing JSON (HTTP header or WebSocket extension) might do the trick, if timewise
  - `JSON + Gzip - gained transmission time < JSON`
  - `JSON + Gzip < msgpack`
- Your use case isn't likely to match mine (think about it, really!)

Update:
- V8's native JSON has a clever strategy to prevent allocations
- `Array` and `Object` are higher level types, so they inherit the complexity of their content
- `Boolean`, `Number`, `undefined` and `null` can be written directly to `ArrayBufferView` (no big deal)
- `String` has to be transformed to `Uint16Array` (no big deal) and back (big deal)
    - See `string-buffer.coffee` (100,000 roundtrips on `Hello World!`: 28ms vs. 41ms)
    - JavaScript has no real means of pre-allocating strings, thus we can only get close to V8's native JSON
