(function() {
  var Package, async, basename, compilers, ejs, extname, fs, joinPath, _, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = Array.prototype.slice;

  _ = require("underscore");

  async = require("async");

  fs = require("fs");

  _ref = require("path"), joinPath = _ref.join, basename = _ref.basename, extname = _ref.extname;

  compilers = require("./compilers");

  ejs = require("ejs");

  Package = (function() {

    function Package(name) {
      this.name = name;
      this.server = __bind(this.server, this);
      this.compileDir = __bind(this.compileDir, this);
      this.add = __bind(this.add, this);
      this.paths = [];
    }

    Package.prototype.add = function(options) {
      if (_.isString(options)) {
        return this.paths.push({
          path: options,
          prefix: ''
        });
      } else {
        return this.paths.push(_.pick(options, 'path', 'prefix'));
      }
    };

    Package.prototype.compile = function(cb) {
      var _this = this;
      return async.map(this.paths, this.compileDir, function(err, modules) {
        if (err) return cb(err);
        modules = _.extend.apply(_, [{}].concat(__slice.call(modules)));
        return cb(null, _this.join(modules));
      });
    };

    Package.prototype.compileDir = function(_arg, cb) {
      var modules, path, prefix, walk,
        _this = this;
      path = _arg.path, prefix = _arg.prefix;
      modules = {};
      walk = function(path, prefix, cb) {
        return fs.readdir(path, function(err, files) {
          if (err) return cb(err);
          return async.forEach(files, function(file, cb) {
            var fullPath, module;
            fullPath = joinPath(path, file);
            module = joinPath(prefix, basename(file, extname(file)));
            return fs.stat(fullPath, function(err, stats) {
              if (err) return cb(err);
              if (stats.isDirectory()) {
                return walk(fullPath, module, cb);
              } else if (stats.isFile()) {
                return _this.compileModule(module, fullPath, function(err, output) {
                  if (err) return cb(err);
                  modules[module] = output;
                  return cb(null);
                });
              }
            });
          }, cb);
        });
      };
      return walk(path, prefix, function(err) {
        return cb(err, modules);
      });
    };

    Package.prototype.compileModule = function(name, file, cb) {
      var _this = this;
      return fs.readFile(file, function(err, source) {
        var compile, output;
        if (err) return cb(err);
        compile = _this.getCompiler(file);
        try {
          output = compile(source.toString(), file);
          return cb(null, output);
        } catch (err) {
          return cb(err);
        }
      });
    };

    Package.prototype.getCompiler = function(file) {
      var ext;
      ext = extname(file).slice(1);
      return (typeof compilers[ext] === "function" ? compilers[ext]() : void 0) || compilers['*']();
    };

    Package.prototype.template = ejs.compile(fs.readFileSync(__dirname + '/../assets/package.ejs').toString());

    Package.prototype.join = function(modules) {
      return this.template({
        modules: modules
      });
    };

    Package.prototype.server = function(req, res, next) {
      return this.compile(function(err, source) {
        if (err) {
          return next(err);
        } else {
          res.writeHead(200, {
            'Content-Type': 'application/javascript'
          });
          return res.end(source);
        }
      });
    };

    return Package;

  })();

  module.exports = Package;

}).call(this);
