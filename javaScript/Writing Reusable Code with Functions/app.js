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

// // === Function Arguments ===
// function greet(person) {
//   console.log(`Hi ${person}!`);
// }
// greet("Andrew");

function square(num) {
  console.log(num * num);
}

square(4);

function sum(x, y) {
  console.log(x + y);
}

// ===  Order matters on functions

function divide(a, b) {
  console.log(a / b);
}

divide(4, 5);
divide(5, 4);
