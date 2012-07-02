fs = require 'fs'
http = require 'http'
Package = require '../package'

server = (argv) ->
  fs.readFile argv.config, (err, file) ->
    throw err if err

    json = JSON.parse(file)
    pkg = new Package(json.name)

    for file in json.files
      pkg.add(path: file, prefix: json.name)

    http.createServer(pkg.server).listen(argv.port)

server.options =
  port:
    alias: 'p'
    default: 8642
  config:
    alias: 'c'
    default: './package.json'

module.exports = server
