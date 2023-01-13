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

// Shorthand 
const math = {
  add(x, y) {
    return x + y
  },
  subtract(x, y) {
    return x - y
  }
}

// This - Reference current execution scope
// Reference the thing to the left of the dot or window if nothing there.

// Referring to the window
function sayHi() {
  console.log("HI")
  console.log(this);
}

// This references the object that it is inside of
// Arrow functions automaticallly forces it to refer to the window
const person = {
  first: 'Cherilyn',
  last: 'Sarkisian',
  nickName: 'Cher',
  fullName() {
    console.log(`${this.first} ${this.last} AKA ${this.nickName}`);
  }
}


// Arrow functions use the closest this version. 
const annoyer = {
  phrases: ["litreally", "cray cray", "I can't even", "Totes!", "YOLO", "Can't Stop Won't Stop"],
  pickPhrase() { // Selects a random phrase
    const {
      phrases
    } = this;
    const idx = Math.floor(Math.random() * phrases.length)
    return phrases[idx]
  },
  start() { // Selects a random phrase every 2 seconds
    this.timerId = setInterval(() => {
      console.log(this.pickPhrase())
    }, 2000)
  },
  stop() { // Stops the start function
    clearInterval(this.timerId);
  }
}