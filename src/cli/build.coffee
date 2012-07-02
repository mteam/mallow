fs = require 'fs'
async = require 'async'
mallow = require '../index'

build = (argv) ->
  pkg = mallow(argv.config)

  pkg.compile (err, output) ->
    throw err if err
    file = argv.output or "./#{pkg.name}.js"
    console.info('writing to', file)
    fs.writeFileSync(file, output)

build.options =
  output:
    alias: 'o'
  config:
    alias: 'c'
    default: './package.json'

module.exports = build
