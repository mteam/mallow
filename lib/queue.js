(function() {
  var Module, Package, Queue, async;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  async = require('async');

  Package = require('./package');

  Module = require('./module');

  exports["new"] = function() {
    return new Queue;
  };

  Queue = (function() {

    function Queue() {
      this.invoke = __bind(this.invoke, this);
      var _this = this;
      this.queue = async.queue(this.invoke, 5);
      this.modules = [];
      this.queue.drain = function() {
        return typeof _this.done === "function" ? _this.done() : void 0;
      };
    }

    Queue.prototype.invoke = function(task, cb) {
      console.log("" + task.name);
      return task.fn.call(this, function(err) {
        if (err) {
          console.error(err);
          return process.exit(1);
        } else {
          return cb();
        }
      });
    };

    Queue.prototype.add = function(name, fn) {
      return this.queue.push({
        name: name,
        fn: fn
      });
    };

    Queue.prototype.compilePackage = function(dir) {
      var pkg;
      pkg = Package["new"](dir);
      return this.add("compile package " + pkg.name, function(cb) {
        return pkg.compile(this, cb);
      });
    };

    Queue.prototype.compileModule = function(file, package) {
      var module;
      module = Module["new"](file, package);
      this.modules.push(module);
      return this.add("compile module " + module.name, function(cb) {
        return module.compile(cb);
      });
    };

    return Queue;

  })();

}).call(this);
