// Shorthand Object Properties 
const getStats = (arr) => {
  const max = Math.max(...arr);
  const min = Math.min(...arr);
  const sum = arr.reduce((sum, r) => sum + r);
  const avg = sum / arr.length;
  return {
    max,
    min,
    sum,
    avg
  }
}

// Computed Properties
const role = 'host';
const person = 'Jools Holland';
const role2 = 'Director';
const person2 = 'James Cameron'

const team = {
  [role]: person,
  [role2]: person2
}

// Adding Methods to Objects
// Methods are just functions inside of an object. 
const math = {
  add: function (x, y) {
    return x + y;
  },
  multiply: function (x, y) {
    return x * y;
  },
  subtract: function (x, y) {
    return x - y;
  },
  divide: function (x, y) {
    return x / y;
  }
}

math.add(4, 7);
math.multiply(4, 7);
math.subtract(4, 7);
math.divide(4, 7);