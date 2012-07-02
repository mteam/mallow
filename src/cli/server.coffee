fs = require 'fs'
http = require 'http'
mallow = require '../index'

server = (argv) ->
  pkg = mallow(argv.config)

  http.createServer(pkg.server).listen(argv.port)
  console.log("listening on 0.0.0.0:#{argv.port}")

server.options =
  port:
    alias: 'p'
    default: 8642
  config:
    alias: 'c'
    default: './package.json'

module.exports = server
