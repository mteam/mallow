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
			return cb err if err
			modules = _.extend {}, modules...
			cb null, @join modules

	compileDir: ({path, prefix}, cb) =>
		modules = {}

		walk = (path, prefix, cb) =>

			fs.readdir path, (err, files) =>
				return cb err if err

				async.forEach files, (file, cb) =>
					fullPath = joinPath path, file
					module = joinPath prefix, basename(file, extname(file))

					fs.stat fullPath, (err, stats) =>
						return cb err if err

						if stats.isDirectory()
							walk fullPath, module, cb

						else if stats.isFile()
							@compileModule module, fullPath, (err, output) ->
								return cb err if err
								modules[module] = output
								cb null

				, cb


		walk path, prefix, (err) ->
			cb err, modules
		
	compileModule: (name, file, cb) ->
		fs.readFile file, (err, source) =>
			return cb err if err

			compile = @getCompiler file

			try
				output = compile source.toString(), file
				cb null, output
			catch err
				cb err

	getCompiler: (file) ->
		ext = extname(file)[1..-1]
		compilers[ext]?() or compilers['*']()

	template: ejs.compile fs.readFileSync(__dirname + '/../assets/package.ejs').toString()

	join: (modules) ->
		@template {modules}
	
	server: (req, res, next) =>
		@compile (err, source) ->
			if err
				next err
			else
				res.writeHead 200, 'Content-Type': 'application/javascript'
				res.end source

module.exports = Package
