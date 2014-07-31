#!/usr/bin/env node
var spawn = require('child_process').spawn;
var port = 3000

var workingDir = process.env.WORKING_DIR || process.env.PACKAGE_DIR || './';
var args = ['test-packages', '--once', '-p', port];
if (typeof process.env.PACKAGES === 'undefined') {
  args.push('./');
}
else if (process.env.PACKAGES !== '') {
  args = args.concat(process.env.PACKAGES.split(';'));
}
var meteor = spawn((process.env.TEST_COMMAND || 'mrt'), args, {cwd: workingDir});
meteor.stdout.pipe(process.stdout);
meteor.stderr.pipe(process.stderr);
meteor.on('close', function (code) {
  console.log('mrt exited with code ' + code);
  process.exit(code);
});

meteor.stdout.on('data', function startTesting(data) {
  var data = data.toString();
  if(data.match(/10015|test-in-browser listening/)) {
    console.log('starting testing...');
    meteor.stdout.removeListener('data', startTesting);
    runTestSuite()
  }
});

function runTestSuite() {
  var args = ['sauce.coffee', 'saucelabs-config.json', 'localhost:' + port];
  var sauce = spawn('coffee', args, {cwd: workingDir});
  sauce.stdout.pipe(process.stdout);
  sauce.stderr.pipe(process.stderr);

  sauce.on('close', function(code) {
    meteor.kill('SIGQUIT');
    process.exit(code);
  });
}
