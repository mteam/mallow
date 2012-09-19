async = require 'async'
ejs = require 'ejs'
Queue = require './queue'

class Bundle
  @template: ejs.compile(require('fs').readFileSync(__dirname + '/../lib/bundle_template.ejs', 'utf-8'))

  constructor: () ->
    @packages = []

  compile: (compiled) ->
    queue = Queue.new()

    queue.done = ->
      output = Bundle.template(modules: queue.modules)
      compiled(output)

    for pkg in @packages
      queue.compilePackage(pkg)
    
  add: (dir) ->
    @packages.push(dir)
    
  server: (req, res, next) =>
    @compile (output, err) ->
      if err then return next(err)
      res.type('js')
      res.end(output)

module.exports = Bundle
