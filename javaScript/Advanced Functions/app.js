// Understand Scope
// Write Higher Order Functions
// Pass functions as callbacks

// === Scope ===
// The location where a variable is defined

// function helpMe() {
//   let msg = "I'm on fire!";
//   return msg;
//}
// msg is scoped to the helpMe() function

// function lol() {
//   let person = "Tom";
//   const age = 45;
//   var color = "teal";
//   console.log(age);
// }

// function changeColor() {
//   let color = "purple";
//   const age = 19;
//   console.log(age);
// }

// Lexical Scope

// function outer() {
//   let movie = "Amadeus";
//   function inner() {
//     console.log(movie.toUpperCase());
//   }
//   inner();
// }

// ===== Function Expression

const add = function (x, y) {
  return x + y;
};

const subtract = function (x, y) {
  return x - y;
};

const multiply = function (x, y) {
  return x * y;
};

const divide = function (x, y) {
  return x / y;
};

const operations = [add, subtract, multiply, divide];

for (let func of operations) {
  let result = func(30, 5);
  console.log(result);
}
