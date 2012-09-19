Bundle = require './bundle'

exports.new = (dir) ->
  bundle = new Bundle
  bundle.add(dir)
  bundle

exports.errorHandler = (err, req, res, next) ->
  if res.getHeader('Content-Type') is 'application/javascript'
    res.send(500, "console.error(#{JSON.stringify(err.toString())});")
  else
    next(err)
