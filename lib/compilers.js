(function() {
  var coffee, extname, fs, path;

  fs = require('fs');

  path = require('path');

  coffee = require('coffee-script');

  extname = function(file) {
    return path.extname(file).slice(1);
  };

  exports.extensions = {
    coffee: function(input, filename) {
      return coffee.compile(input, {
        bare: true,
        filename: filename
      });
    },
    json: function(input) {
      return "module.exports = " + input + ";\n";
    },
    js: function(input) {
      return input;
    }
  };

  exports.canCompile = function(file) {
    return exports.extensions[extname(file)] != null;
  };

  exports.compile = function(file, cb) {
    var compiler;
    compiler = exports.extensions[extname(file)];
    if (compiler != null) {
      return fs.readFile(file, 'utf-8', function(err, contents) {
        if (err) {
          return cb(err);
        } else {
          return cb(null, compiler(contents));
        }
      });
    } else {
      return cb("no compiler found for " + file);
    }
  };

}).call(this);
