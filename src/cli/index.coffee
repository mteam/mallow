optimist = require 'optimist'

exports.run = ->
  argv = optimist.argv

  if argv._[0]?
    try
      require.resolve("./#{ argv._[0] }")
    catch error
      console.log("'#{ argv._[0] }' - no such command")
      return
    cmd = require "./#{ argv._[0] }"

  if cmd
    cmd(optimist.options(cmd.options).argv)
