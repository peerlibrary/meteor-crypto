crypto = Npm.require 'crypto'

Crypto =
  SHA256: class extends Crypto.SHA256
    constructor: (params) ->
      super
      @_total = 0
      @_hash = crypto.createHash 'sha256'

    update: (data, callback) =>
      throw new Error "No data given" if not data

      try
        @_hash.update data
        @_total += data.length
      catch error
        # If callback is given we use it for reporting
        # the error, otherwise we rethrow
        return callback error if callback
        throw error

      # We ignore the result from onProgress because we are processing all data
      # in update in one chunk anyway and there is nothing to prematurely abort
      if @size?
        @onProgress @_total / @size
      else
        @onProgress()

      callback? null

    finalize: (callback) =>
      try
        sha256 = @_hash.digest 'hex'
      catch error
        # If callback is given we use it for reporting
        # the error, otherwise we rethrow
        return callback error if callback
        throw error

      callback? null, sha256
      sha256
