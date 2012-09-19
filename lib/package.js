(function() {
  var Package, async, compilers, fs, glob, path;

  fs = require('fs');

  path = require('path');

  glob = require('glob');

  async = require('async');

  compilers = require('./compilers');

  exports["new"] = function(dir) {
    return new Package(dir);
  };

  Package = (function() {

    function Package(dir) {
      this.dir = dir;
      this.name = path.basename(this.dir);
    }

    Package.prototype.compile = function(queue, cb) {
      var _this = this;
      return async.series([
        function(cb) {
          return _this.readPackageJson(cb);
        }, function(cb) {
          return _this.loadDependencies(queue, cb);
        }, function(cb) {
          return _this.compileModules(queue, cb);
        }
      ], cb);
    };

    Package.prototype.readPackageJson = function(cb) {
      var file;
      var _this = this;
      file = path.join(this.dir, 'package.json');
      return fs.readFile(file, function(err, contents) {
        if (err) return cb(err);
        _this.json = JSON.parse(contents);
        if (!(_this.json.directories != null)) {
          return cb("no directories specified in " + _this.json.name + "/package.json");
        }
        if (!(_this.json.directories.source != null)) {
          return cb("no source directory specified in " + _this.json.name + "/package.json");
        }
        _this.name = _this.json.name;
        _this.sources = path.join(_this.dir, _this.json.directories.source);
        return cb();
      });
    };

    Package.prototype.loadDependencies = function(queue, cb) {
      var deps, pattern;
      if (!(this.json.directories.dependencies != null)) return cb();
      deps = this.json.directories.dependencies;
      pattern = path.join(this.dir, deps, '*', 'package.json');
      return glob(pattern, function(err, packages) {
        var package, _i, _len;
        if (err) return cb(err);
        for (_i = 0, _len = packages.length; _i < _len; _i++) {
          package = packages[_i];
          queue.compilePackage(path.dirname(package));
        }
        return cb();
      });
    };

    Package.prototype.compileModules = function(queue, cb) {
      var pattern;
      var _this = this;
      pattern = path.join(this.sources, '**', '*.*');
      return glob(pattern, function(err, modules) {
        var file, _i, _len;
        if (err) return cb(err);
        for (_i = 0, _len = modules.length; _i < _len; _i++) {
          file = modules[_i];
          if (compilers.canCompile(file)) queue.compileModule(file, _this);
        }
        return cb();
      });
    };

    return Package;

  })();

}).call(this);
