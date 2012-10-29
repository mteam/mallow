fs = require 'fs'
path = require 'path'
glob = require 'glob'
async = require 'async'
compilers = require './compilers'

exports.new = (dir) ->
  new Package(dir)

class Package
  constructor: (@dir) ->
    @name = path.basename(@dir)

  compile: (queue, cb) ->
    async.series([
      @readPackageJson.bind(this),
      @loadDependencies.bind(this, queue),
      @compileModules.bind(this, queue)
    ], cb)

  readPackageJson: (cb) ->
    file = path.join(@dir, 'package.json')

    fs.readFile file, (err, contents) =>
      if err then return cb(err)

      try
        @json = JSON.parse(contents)
      catch err
        return cb("invalid package.json in #{@name}")

      if not @json.directories?
        return cb("no directories specified in #{@json.name}/package.json")
      
      if not @json.directories.source?
        return cb("no source directory specified in #{@json.name}/package.json")

      @name = @json.name
      @sources = path.join(@dir, @json.directories.source)

      cb()

  loadDependencies: (queue, cb) ->
    if not @json.directories.dependencies?
      return cb()

    deps = @json.directories.dependencies
    pattern = path.join(@dir, deps, '*', 'package.json')

    glob pattern, (err, packages) ->
      if err then return cb(err)

      for pkg in packages
        queue.compilePackage(path.dirname(pkg))

      cb()

  compileModules: (queue, cb) ->
    pattern = path.join(@sources, '**', '*.*')

    glob pattern, (err, modules) =>
      if err then return cb(err)

      for file in modules when compilers.canCompile(file)
        queue.compileModule(file, this)

      cb()
