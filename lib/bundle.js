(function() {
  var Bundle, Queue, async, ejs;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  async = require('async');

  ejs = require('ejs');

  Queue = require('./queue');

  Bundle = (function() {

    Bundle.template = ejs.compile(require('fs').readFileSync(__dirname + '/../lib/bundle_template.ejs', 'utf-8'));

    function Bundle() {
      this.server = __bind(this.server, this);      this.packages = [];
    }

    Bundle.prototype.compile = function(compiled) {
      var pkg, queue, _i, _len, _ref, _results;
      queue = Queue["new"]();
      queue.done = function() {
        var output;
        output = Bundle.template({
          modules: queue.modules
        });
        return compiled(output);
      };
      _ref = this.packages;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pkg = _ref[_i];
        _results.push(queue.compilePackage(pkg));
      }
      return _results;
    };

    Bundle.prototype.add = function(dir) {
      return this.packages.push(dir);
    };

    Bundle.prototype.server = function(req, res, next) {
      return this.compile(function(output, err) {
        if (err) return next(err);
        res.type('js');
        return res.end(output);
      });
    };

    return Bundle;

  })();

  module.exports = Bundle;

}).call(this);
