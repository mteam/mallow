Package = require "./package"

module.exports = (fn) ->
	packages = {}

	fn.apply package: (name, fn) ->
		packages[name] = pkg = new Package(name)
		fn.apply add: pkg.add

	packages
