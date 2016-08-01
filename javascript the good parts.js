// JavaScript: The Good Parts by Douglas Crockford. Copyright 2008 Yahoo! Inc., 978-0-596-51774-8.

Function.prototype.method = function (name, func) {
  this.prototype[name] = func;
  return this;
};

if (typeof Object.create !== 'function') {
  Object.create = function (o) {
    var F = function () {};
    F.prototype = o;
    return new F();
  };
}

Function.method('curry', function ( ) {
  var slice = Array.prototype.slice,
  args = slice.apply(arguments),
  that = this;
  return function ( ) {
    return that.apply(null, args.concat(slice.apply(arguments)));
  };
});

var memoizer = function (memo, fundamental) {
  var shell = function (n) {
    var result = memo[n];
    if (typeof result !== 'number') {
      result = fundamental(shell, n);
      memo[n] = result;
    }
    return result;
  };
  return shell;
};

Object.method('superior', function (name) {
  var that = this,
  method = that[name];
  return function ( ) {
    return method.apply(that, arguments);
  };
});

var is_array = function (value) {
  return value &&
  typeof value === 'object' &&
  value.constructor === Array;
};

var is_array = function (value) {
  return value &&
  typeof value === 'object' &&
  typeof value.length === 'number' &&
  typeof value.splice === 'function' &&
  !(value.propertyIsEnumerable('length'));
};

Array.method('reduce', function (f, value) {
  var i;
  for (i = 0; i < this.length; i += 1) {
    value = f(this[i], value);
  }
  return value;
});

Array.dim = function (dimension, initial) {
var a = [], i;
for (i = 0; i < dimension; i += 1) {
a[i] = initial;
}
return a;
};

Array.matrix = function (m, n, initial) {
var a, i, j, mat = [];
for (i = 0; i < m; i += 1) {
a = [];
for (j = 0; j < n; j += 1) {
a[j] = initial;
}
mat[i] = a;
}
return mat;
};

Array.identity = function (n) {
var i, mat = Array.matrix(n, n, 0);
for (i = 0; i < n; i += 1) {
mat[i][i] = 1;
}
return mat;
};

