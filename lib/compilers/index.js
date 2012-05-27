(function() {

  module.exports = {
    coffee: function() {
      return require("./coffee");
    },
    json: function() {
      return require("./json");
    },
    '*': function() {
      return require("./dummy");
    }
  };

}).call(this);
