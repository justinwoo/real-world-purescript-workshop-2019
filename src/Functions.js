exports.jsAdd4 = function(a, b, c, d) {
  return a + b + c + d;
};

exports.jsLogInt = function(i) {
  return function() {
    console.log(i.toString());
  };
};

exports.jsUnthunkedLogInt = function(i) {
  console.log(i.toString());
};

exports._index = function(just) {
  return function(nothing) {
    return function(index) {
      return function(array) {
        if (array.length > index) {
          return just(array[index]);
        } else {
          return nothing;
        }
      };
    };
  };
};
