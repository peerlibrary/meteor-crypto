Package.describe({
  summary: "Efficient crypto operations in web workers",
  version: '0.1.2',
  name: 'mrt:crypto',
  git: 'https://github.com/peerlibrary/meteor-crypto.git'
});

Package.on_use(function (api) {
  api.imply('peerlibrary:crypto@0.1.2');
});
