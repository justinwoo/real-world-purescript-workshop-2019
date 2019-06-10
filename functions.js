// run spago build first
const output = require('./output/ZZZ.Functions');

console.log('add2', output.add2(1)(1));
console.log('add3', output.add3(1)(1)(1));
console.log('add4', output.add4(1)(1)(1)(1));

console.log('add2Fn2', output.add2Fn2(1, 1));
console.log('add2Fn3', output.add3Fn3(1, 1, 1));

console.log('jsAdd4', output.jsAdd4(1, 1, 1, 1));

console.log('logInt', output.logInt(1)());
console.log('jsLogInt', output.jsLogInt(1)());

console.log('unthunkedLogInt', output.unthunkedLogInt(1));
console.log('jsUnthunkedLogInt', output.jsUnthunkedLogInt(1));

console.log('rethunkedLogInt', output.rethunkedLogInt(1)());
