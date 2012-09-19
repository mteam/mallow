async = require 'async'
ejs = require 'ejs'
Queue = require './queue'

class Bundle
  @template: ejs.compile(require('fs').readFileSync(__dirname + '/../lib/bundle_template.ejs', 'utf-8'))

  constructor: () ->
    @packages = []

  compile: (cb) ->
    queue = Queue.new()

    queue.done = (err) ->
      if err then return cb(err)

      output = Bundle.template(modules: queue.modules)
      cb(null, output)

    for pkg in @packages
      queue.compilePackage(pkg)
    
  add: (dir) ->
    @packages.push(dir)
    
  server: (req, res, next) =>
    res.type('js')
    
    @compile (err, output) ->
      if err then return next(err)
      res.end(output)

module.exports = Bundle
