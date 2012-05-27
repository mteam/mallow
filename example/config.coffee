module.exports = ->
	@package 'app.js', ->
		@add prefix: 'example', path: __dirname + '/hello'
		@add prefix: 'foo', path: __dirname + '/foo'
