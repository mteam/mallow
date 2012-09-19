(function() {
  var Module, compilers, path;

  path = require('path');

  compilers = require('./compilers');

  exports["new"] = function(file, pkg) {
    return new Module(file, pkg);
  };

  Module = (function() {

    function Module(file, package) {
      this.file = file;
      this.package = package;
    }

    Module.prototype.compile = function(cb) {
      var _this = this;
      return compilers.compile(this.file, function(err, source) {
        _this.source = source;
        return cb(err);
      });
    };

    Object.defineProperties(Module.prototype, {
      name: {
        get: function() {
          var ext, noext, relative;
          relative = path.relative(this.package.sources, this.file);
          ext = path.extname(this.file);
          noext = relative.slice(0, -ext.length);
          return path.join(this.package.name, noext);
        }
      }
    });

    return Module;

  })();

}).call(this);
