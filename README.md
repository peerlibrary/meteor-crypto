Crypto
======

Meteor smart package which provides a [web workers](https://en.wikipedia.org/wiki/Web_worker) enhanced
efficient crypto operations. Instead of computing computationally intensive crypto operations in main
thread of user's browser it uses a web worker, if possible.

Adding this package to your [Meteor](http://www.meteor.com/) application adds `Crypto` object into the global scope.

Both client and server side. It provides equivalent API on the server side.

Installation
------------

```
mrt add crypto
```

API
---

`var sha256 = new Crypto.SHA256(params)` creates an object representing a new SHA256 computation. It takes object `params`:

 * `onProgress(progress)`: progress callback function (optional)
    * `progress`: float, between 0 and 1 (inclusive), if it can be computed
 * `size`: complete file size, if known (optional)

`sha256.update(data, callback)` updates the hash content with the given data:

 * `data`: chunk of data to be added for hash computation (required)
 * `callback(error)`: callback function (optional)
    * `error`: error or null if there is no error

`sha256.finalize(callback)` updates the hash content with the given data:

 * `callback(error, sha256)`: callback function (required on client)
    * `error`: error or null if there is no error
    * `sha256`: result as a hex string

On the server side callbacks are not required. Methods are run synchronous
anyway.
