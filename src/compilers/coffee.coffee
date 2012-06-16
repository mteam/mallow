coffee = require "coffee-script"

module.exports = (input, filename) ->
	coffee.compile input, bare: true, filename: filename
