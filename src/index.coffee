Bundle = require './bundle'

exports.new = (dir) ->
  bundle = new Bundle
  bundle.add(dir)
  bundle
