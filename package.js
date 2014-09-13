Package.describe({
  summary: "Efficient crypto operations in web workers",
  version: '0.1.2',
  name: 'peerlibrary:crypto',
  git: 'https://github.com/peerlibrary/meteor-crypto.git'
});

Package.on_use(function (api) {
  api.versionsFrom('METEOR@0.9.1.1');
  api.use(['coffeescript', 'underscore', 'peerlibrary:assert@0.2.5'], ['client', 'server']);

  api.export('Crypto');

  api.add_files([
    'lib.coffee'
  ], ['client', 'server']);

  api.add_files([
    'arraybuffer.coffee',
    'client.coffee'
  ], 'client' );

  api.add_files([
    'server.coffee'
  ], 'server' );

  // We have to add digest.js in two ways, to be available
  // in a fallback worker, and in a web worker
  api.add_files([
    'digest.js/digest.js'
  ], 'client', {bare: true});

	api.add_files([
		'digest.js/digest.js',
		'assets/worker.js'
	], 'client', {isAsset: true});
});

Package.on_test(function (api) {
  api.use(['peerlibrary:crypto', 'tinytest', 'test-helpers', 'coffeescript', 'underscore', 'peerlibrary:async@0.9.0-2', 'peerlibrary:blob@0.1.2'], ['client', 'server']);

  api.add_files([
    'tests/common.coffee',
    'tests/defined.coffee'
  ], ['client', 'server']);

  api.add_files([
    'tests/client.coffee'
  ], 'client');

  api.add_files([
    'tests/server.coffee'
  ], 'server');

  api.add_files([
    'assets/test.pdf'
  ], ['client', 'server'], {isAsset: true});
});
