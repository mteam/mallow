async = require 'async'
Package = require './package'
Module = require './module'

exports.new = ->
  new Queue

class Queue
  constructor: ->
    @queue = async.queue @invoke, 5
    @modules = []

    @queue.drain = => @done?()

  invoke: (task, cb) =>
    console.log("#{task.name}")
    task.fn.call this, (err) =>
      if err
        @stop(err)
      else
        cb()

  add: (name, fn) ->
    @queue.push {name, fn}

  stop: (err) ->
    @queue.concurrency = 0
    @done?(err)

  compilePackage: (dir) ->  
    pkg = Package.new(dir)

    @add "compile package #{pkg.name}", (cb) ->
      pkg.compile(this, cb)

  compileModule: (file, pkg) ->
    module = Module.new(file, pkg)
    @modules.push(module)

    @add "compile module #{module.name}", (cb) ->
      module.compile(cb)
