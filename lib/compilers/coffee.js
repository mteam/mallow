(function() {
  var coffee;

  coffee = require("coffee-script");

  module.exports = function(input) {
    return coffee.compile(input, {
      bare: true
    });
  };

}).call(this);
