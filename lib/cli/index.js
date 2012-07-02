// Generated by CoffeeScript 1.3.3
(function() {
  var optimist;

  optimist = require('optimist');

  exports.run = function() {
    var argv, cmd;
    argv = optimist.argv;
    if (argv._[0] != null) {
      try {
        require.resolve("./" + argv._[0]);
      } catch (error) {
        console.log("'" + argv._[0] + "' - no such command");
        return;
      }
      cmd = require("./" + argv._[0]);
    }
    if (cmd) {
      return cmd(optimist.options(cmd.options).argv);
    }
  };

}).call(this);