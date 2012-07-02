fs = require 'fs'
async = require 'async'
Package = require '../package'

build = (argv) ->
  pkg = null

  async.waterfall [

    (cb) ->
      fs.readFile(argv.config, cb)

    (file, cb) ->
      json = JSON.parse(file)
      pkg = new Package(json.name)

      for file in json.files
        pkg.add(path: file, prefix: json.name)

      pkg.compile(cb)

    (compiled, cb) ->
      output = argv.output or "./#{pkg.name}.js"
      console.info('writing to', output)
      fs.writeFile(output, compiled, cb)

  ], (err) ->
    throw err if err

build.options =
  output:
    alias: 'o'
  config:
    alias: 'c'
    default: './package.json'

module.exports = build
