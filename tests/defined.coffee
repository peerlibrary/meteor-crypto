Tinytest.add 'crypto - defined', (test) ->
  isDefined = false
  try
    Crypto
    isDefined = true
  test.isTrue isDefined, "Crypto is not defined"
  test.isTrue Package['peerlibrary:crypto'].Crypto, "Package.peerlibrary:crypto.Crypto is not defined"
