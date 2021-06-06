// ==== Functions ====
// Functions allow use to write reusable modular code
// Define a "chunk" of code that we can then execute at a later point

// function funcName(){
// do something
// }
// function grumpus() {
//   console.log("ugh... you again");
//   console.log("FOR THE LAST TIME...");
//   console.log("LEAVE ME ALONE");
// }
// for (let i = 0; i <= 15; i++) {
//   grumpus();
// }

// ==== Dice Roll ====
// function rollDie() {
//   let roll = Math.floor(Math.random() * 6 + 1);
//   console.log(`Rolled: ${roll}`);
// }

// function throwDice(numRolls) {
//   console.log(`Number of Dice Rolled: ${numRolls}`);
//   for (let i = 0; i < numRolls; i++) {
//     rollDie();
//   }
// }
// throwDice(3);

// // ========== Function Arguments ==========
// function greet(person) {
//   console.log(`Hi ${person}!`);
// }
// greet("Andrew");
// function square(num) {
//   console.log(num * num);
// }

// ======= Functions with Multiple Arguments / Params =======
// square(4);
// function sum(x, y) {
//   console.log(x + y);
// }

// ===  Order matters on functions ========
// function divide(a, b) {
//   console.log(a / b);
// }
// divide(4, 5);
// divide(5, 4);

// ======== Return ========
// Return values allow you to capture them in a variable
// function add(x, y) {
//   return x + y;
// }
// const total = add(4, 5);
// Must return only one thing at a time
// After a return statement runs the function will stop
// function square(x) {
//   return x * x;
//   console.log("ALL DONE!");
// }
// ====== More on Return Values
// function isPurple(color) {
//   if (color.toLowerCase() === "purple") {
//     return true;
//   }
//   return false;
// }
// function isPurple(color) {
//   return color.toLowerCase() === "purple";
// }
// function containsPurple(arr) {
//   for (let color of arr) {
//     if (color === "purple" || color === "magenta") {
//       return true;
//     }
//   }
//   return false;
// }

// Write a function to find the average value in an array of numbers
//avg([0,50]) //25
//avg([75,76,80,95,100]) //85.2

function isPangram(sentence) {
  for (let char of "abcdefghijklmnopqrstuvwxyz") {
    if (sentence.toLowerCase().indexOf(char) === -1) {
      return false;
    }
  }
  return true;
}

isPangram("The five boxing wizards jump quickly");
isPangram("The five boxing wizards jump quick");
