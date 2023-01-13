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

// const add = function (x, y) {
//   return x + y;
// };

// const subtract = function (x, y) {
//   return x - y;
// };

// const multiply = function (x, y) {
//   return x * y;
// };

// const divide = function (x, y) {
//   return x / y;
// };

// const operations = [add, subtract, multiply, divide];

// for (let func of operations) {
//   let result = func(30, 5);
//   console.log(result);
// }

// ======= Functions as Arugemnts

// function callTwice(func) {
//   func();
//   func();
// }

// function laugh() {
//   console.log("HAHAHAHAH");
// }

// function rage() {
//   console.log("I HATE EVERYTHING");
// }

// function repeatNTime(action, num) {
//   for (let i = 0; i < num; i++) {
//     action();
//   }
// }

// function pickOne(f1, f2) {
//   let rand = Math.random();
//   if (rand < 0.5) {
//     f1();
//   } else {
//     f2();
//   }
// }

// pickOne(laugh, rage);

// function multiplyBy(num) {
//   return function (x) {
//     return x * num;
//   };
// }

// const triple = multiplyBy(3);
// const double = multiplyBy(2);
// const halve = multiplyBy(0.5);

// triple(6);

// function makeBetweenFunc(x,y);{
// return function(num){
//   return num >= x && num <= y;
//   }
// }

// const isChild = makeBetweenFunc(0, 17);
// const bornInNinties = makeBetweenFunc(1990, 1999);
// const isNiceWeather = makeBetweenFunc(65, 79);

// function grumpus(){
//     alert("GAHHH GO AWAY!")
// }

// setTimeout(function(){
//     alert("WELCOME!");
// }, 5000);

const btn = document.querySelector('button');
btn.addEventListener('click', function () {
  alert("Can't You Read!")
})

// ==== HOISTING ==== 