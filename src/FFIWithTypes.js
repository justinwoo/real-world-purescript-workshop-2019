exports.process = function() {
  return global.process;
};

exports.processExit = function(process) {
  return function() {
    process.exit();
  };
};

exports.jsonParse = function(string) {
  return function() {
    JSON.parse(string);
  };
};

exports._readString = function(left) {
  return function(right) {
    return function(f) {
      if (typeof f === "string") {
        return right(f);
      } else {
        return left("expected string, was " + typeof f);
      }
    };
  };
};

exports.checkTypeOf = function(f) {
  return typeof f;
};

exports._readProp = function(left) {
  return function(right) {
    return function(key) {
      return function(f) {
        if (!f) {
          return left("expected object was falsy");
        } else {
          if (f.hasOwnProperty(key)) {
            return right(f[key]);
          } else {
            return left("expected object did not have a property at " + key);
          }
        }
      };
    };
  };
};
