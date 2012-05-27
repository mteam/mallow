coffee = require "coffee-script"

module.exports = (input) ->
	coffee.compile input, bare: true
