(function() {
  var Package, compilers;

  Package = require("./package");

  compilers = require("./compilers");

  module.exports = function(fn) {
    var packages;
    packages = {};
    fn.apply({
      package: function(name, fn) {
        var pkg;
        packages[name] = pkg = new Package(name);
        return fn.apply({
          add: pkg.add
        });
      }
    });
    return packages;
  };

  module.exports.compilers = compilers;

}).call(this);
