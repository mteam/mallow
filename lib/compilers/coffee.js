(function() {
  var coffee;

  coffee = require("coffee-script");

  module.exports = function(input, filename) {
    return coffee.compile(input, {
      bare: true,
      filename: filename
    });
  };

}).call(this);
