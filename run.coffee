zlib = require 'zlib'
msgpack = require 'msgpack'
msgpackJS = require 'msgpack-js'
msgpackJS5 = require 'msgpack-js-v5'
purepack = require 'purepack'

gzip = zlib.createGzip()

bench = (obj, cycles) ->
	results = {}
	done = 0
	print = ->
		console.log 'Name | Time | % | Size | % | Gzip Size | %'
		console.log '--- | --- | --- | --- | --- | --- | ---'
		for name, data of results
			console.log name, 
					'|', data.time + 'ms', 
					'|', Math.round(100 * data.time / results.JSON.time) + '%',
					'|', data.size + ' bytes',
					'|', Math.round(100 * data.size / results.JSON.size) + '%',
					'|', data.gzipSize + ' bytes',
					'|', Math.round(100 * data.gzipSize / results.JSON.gzipSize) + '%'


	start = Date.now()
	for i in [0..cycles]
		encoded = JSON.stringify(obj)
		decoded = JSON.parse(encoded)
	results.JSON = 
		size: encoded.toString('binary').length
		type: typeof encoded
		time: Date.now() - start
	zlib.deflate encoded, (err, buffer) ->
		unless err
			results.JSON.gzipSize = buffer.length
		done++
		print() if done is 5

	start = Date.now()
	for i in [0..cycles]
		encoded = msgpack.pack(obj)
		decoded = msgpack.unpack(encoded)
	end = Date.now()
	results.msgpack = 
		size: encoded.length
		type: typeof encoded
		time: Date.now() - start
	zlib.deflate encoded, (err, buffer) ->
		unless err
			results.msgpack.gzipSize = buffer.length
		done++
		print() if done is 5

	start = Date.now()
	for i in [0..cycles]
		encoded = msgpackJS.encode(obj)
		decoded = msgpackJS.decode(encoded)
	end = Date.now()
	results.msgpackJS = 
		size: encoded.length
		type: typeof encoded
		time: Date.now() - start
	zlib.deflate encoded, (err, buffer) ->
		unless err
			results.msgpackJS.gzipSize = buffer.length
		done++
		print() if done is 5

	start = Date.now()
	for i in [0..cycles]
		encoded = msgpackJS5.encode(obj)
		decoded = msgpackJS5.decode(encoded)
	end = Date.now()
	results.msgpackJS5 = 
		size: encoded.length
		type: typeof encoded
		time: Date.now() - start
	zlib.deflate encoded, (err, buffer) ->
		unless err
			results.msgpackJS5.gzipSize = buffer.length
		done++
		print() if done is 5
			
	start = Date.now()
	for i in [0..cycles]
		encoded = purepack.pack(obj)
		decoded = purepack.unpack(encoded)
	end = Date.now()
	results.purepack = 
		size: encoded.length
		type: typeof encoded
		time: Date.now() - start
	zlib.deflate encoded, (err, buffer) ->
		unless err
			results.purepack.gzipSize = buffer.length
		done++
		print() if done is 5
	


generateObj = (size) ->
	r = {}
	for i in [0..size]
		r['d' + i + 'n'] = i + Math.random()
		r['s' + i + 'n'] = ''
		len = i % 20
		while len--
			r['s' + i + 'n'] += String.fromCharCode( 48 + ~~(Math.random() * 42) )
	return r

console.log 'Small object, 10000 cycles'
bench generateObj(1), 10000

console.log 'Large object, 10 cycles'
bench generateObj(10000), 1
