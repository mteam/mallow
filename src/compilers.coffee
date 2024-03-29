fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'

extname = (file) ->
  path.extname(file)[1..]

exports.extensions =
	coffee: (input, filename) ->
    coffee.compile(input, bare: true, filename: filename)

	json: (input) ->
    "module.exports = #{input};\n"

  js: (input) -> input

exports.canCompile = (file) ->
  exports.extensions[extname(file)]?

exports.compile = (file, cb) ->
  compiler = exports.extensions[extname(file)]

  if compiler?
    fs.readFile file, 'utf-8', (err, contents) ->
      if err then return cb(err)
      
      try
        output = compiler(contents, file)
      catch err
        return cb(err)

      cb(null, output)
  else
    cb("no compiler found for #{file}")
