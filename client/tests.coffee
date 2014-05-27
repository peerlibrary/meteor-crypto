globals = @
fileLoaded = false
queue = []

Tinytest.addAsync 'Checking package visibility', (test, onComplete) ->
  queue.push () ->
    globals.createHash()
    test.isTrue globals.isDefined, "Crypto.SHA256 is not defined"
    test.isTrue Package['crypto'].Crypto.SHA256, "Package.sha256.Crypto.SHA256 is not defined"
    onComplete()
  processQueue()

Tinytest.addAsync 'Checking file size', (test, onComplete) ->
  queue.push () ->
    test.equal globals.pdf.byteLength, pdfByteLength
    onComplete()
  processQueue()

Tinytest.addAsync 'Sending complete file as ArrayBuffer, checking hash', (test, onComplete) ->
  queue.push () ->
    try
      globals.createHash()
      globals.hash.update globals.pdf   # Send complete file to Crypto
      globals.hash.finalize (error, result) ->
        test.equal error, null
        test.equal result, pdfHash
        onComplete()
    catch error
      test.fail(error)
      onComplete()

  processQueue()

Tinytest.addAsync 'Sending complete file as Blob, checking hash', (test, onComplete) ->
  queue.push () ->
    try
      blob = new Blob [globals.pdf]
      globals.createHash()
      globals.hash.update blob
      globals.hash.finalize (error, result) ->
        test.equal error, null
        test.equal result, pdfHash
        onComplete()
    catch error
      test.fail(error)
      onComplete()
  processQueue()

Tinytest.addAsync 'Sending file in regular chunks, checking hash', (test, onComplete) ->
  queue.push () ->
    globals.createHash()

    globals.chunkStart = 0
    globals.sendChunk() while globals.chunkStart < pdf.byteLength

    globals.hash.finalize (error, result) ->
      test.equal error, null
      test.equal result, pdfHash
      onComplete()
  processQueue()

Tinytest.addAsync 'Sending file in irregular chunks, check hashing', (test, onComplete) ->
  queue.push () ->
    globals.createHash()
    globals.chunkStart = 0
    while globals.chunkStart < globals.pdf.byteLength
      globals.sendChunk true # true is for random
    globals.hash.finalize (error, result) ->
      test.equal error, null
      test.equal result, pdfHash
      onComplete()
  processQueue()

Tinytest.addAsync 'Checking progress callback', (test, onComplete) ->
  round = (number) ->
    number.toPrecision 5
  queue.push () ->
    chunkCount = globals.pdf.byteLength / globals.chunkSize
    progressStep = 1 / chunkCount
    expectedProgress = 0

    globals.createHash (progress) ->
      expectedProgress += progressStep
      expectedProgress = 1 if expectedProgress > 1
      test.equal round(progress), round(expectedProgress)

    globals.hash.update globals.pdf
    globals.hash.finalize (error, result) ->
      onComplete()
  processQueue()

# Process queue
processQueue = () ->
  return if not fileLoaded
  test() while test = queue.shift()

# Download file using XMLHttpRequest
# not using jQuery or HTTP package because they don't support arraybuffer response
pdfPath = "#{ testRoot }/#{ pdfFilename }?" + Math.random()
oReq = new XMLHttpRequest
oReq.open "GET", pdfPath, true
oReq.responseType = 'arraybuffer'
oReq.onload = (oEvent) ->
  globals.pdf = oReq.response
  fileLoaded = true
  processQueue()
oReq.send null

