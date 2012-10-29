path = require 'path'
compilers = require './compilers'

exports.new = (file, pkg) ->
  new Module(file, pkg)

class Module
  constructor: (@file, @package) ->

  compile: (cb) ->
    compilers.compile @file, (err, source) =>
      @source = source
      cb(err)

  Object.defineProperties @prototype,
    name:
      get: ->
        relative = path.relative(@package.sources, @file)
        ext = path.extname(@file)
        noext = relative[0...-ext.length]
        path.join(@package.name, noext).replace(/\\/g, '/')
