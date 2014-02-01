ab2str = (bufView) ->
	s = ''
	for i in [0...bufView.length]
		s += String.fromCharCode bufView[i]
	return s

str2ab = (str, bufView) ->
	for i in [0...str.length]
		bufView[i] = str.charCodeAt(i)
	return buf
	
str = "Hello World!"

start = Date.now()
for i in [0..100000]
	encoded = JSON.stringify(str)
	decoded = JSON.parse(encoded)
console.log (Date.now() - start) + 'ms'

# Pre-allocate buffers.
buf = new ArrayBuffer(str.length * 2) # 2 bytes for each char
bufView = new Uint16Array(buf)

start = Date.now()
for i in [0..100000]
	encoded = str2ab(str, bufView)
	decoded = ab2str(bufView)
console.log (Date.now() - start) + 'ms'
