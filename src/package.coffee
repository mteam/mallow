_ = require "underscore"
async = require "async"
fs = require "fs"
{join: joinPath, basename, extname} = require "path"
compilers = require "./compilers"
ejs = require "ejs"

class Package
	constructor: (@name) ->
		@paths = []

	add: (options) =>
		if _.isString options
			@paths.push path: options, prefix: ''
		else
			@paths.push _.pick options, 'path', 'prefix'

	compile: (cb) ->
		async.map @paths, @compileDir, (err, modules) =>
			cb err if err
			modules = _.extend {}, modules...
			cb null, @join modules

	compileDir: ({path, prefix}, cb) =>
		modules = {}

		walk = (path, prefix, cb) =>

			fs.readdir path, (err, files) =>
				cb err if err

				async.forEach files, (file, cb) =>
					fullPath = joinPath path, file
					module = joinPath prefix, basename(file, extname(file))

					fs.stat fullPath, (err, stats) =>
						cb err if err

						if stats.isDirectory()
							walk fullPath, module, cb

						else if stats.isFile()
							@compileModule module, fullPath, (err, output) ->
								cb err if err
								modules[module] = output
								cb null

				, cb


		walk path, prefix, (err) ->
			cb err, modules
		
	compileModule: (name, file, cb) ->
		fs.readFile file, (err, source) =>
			cb err if err

			compile = @getCompiler file
			output = compile source.toString()

			cb null, output

	getCompiler: (file) ->
		ext = extname(file)[1..-1]
		compilers[ext]() or compilers['*']()

	template: ejs.compile fs.readFileSync(__dirname + '/package.ejs').toString()

	join: (modules) ->
		@template {modules}
	
	server: (req, res) =>
		@compile (err, source) ->
			if err
				console.log err
				res.writeHead 500, 'Content-Type': 'text/plain'
				res.end err
			else
				res.writeHead 200, 'Content-Type': 'application/javascript'
				res.end source

module.exports = Package
