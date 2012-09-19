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
    task.fn.call this, (err) ->
      if err
        console.error(err)
        process.exit(1)
      else
        cb()

  add: (name, fn) ->
    @queue.push {name, fn}

  compilePackage: (dir) ->  
    pkg = Package.new(dir)

    @add "compile package #{pkg.name}", (cb) ->
      pkg.compile(this, cb)

  compileModule: (file, package) ->
    module = Module.new(file, package)
    @modules.push(module)

    @add "compile module #{module.name}", (cb) ->
      module.compile(cb)