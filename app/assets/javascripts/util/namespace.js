// eP Namespace Helper
//
// Usage:
//
// _ep.ns('my.name.space') = { myfunction: function() { ... } };
// ...
// _ep.my.name.space.myfunction();

(function(){
  var rootNs = window._ep

  window._ep.ns = function(namespace) {
    var currNs = rootNs;
    if (!namespace) return currNs;
    var segments = namespace.split(".");
    for (var i=0; i<segments.length; i++) {
      if (segStr !== '') {
        var segStr = segments[i];
        var segObj = currNs[segStr];
        currNs[segStr] = segObj ? segObj : {};
        currNs = currNs[segStr];
      }
    }
    return currNs;
  }
})();