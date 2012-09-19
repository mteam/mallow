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
        var output;
        if (err) return cb(err);
        try {
          output = compiler(contents, file);
        } catch (err) {
          return cb(err);
        }
        return cb(null, output);
      });
    } else {
      return cb("no compiler found for " + file);
    }
  };

}).call(this);
