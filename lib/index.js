(function() {
  var Bundle;

  Bundle = require('./bundle');

  exports["new"] = function(dir) {
    var bundle;
    bundle = new Bundle;
    bundle.add(dir);
    return bundle;
  };

}).call(this);
