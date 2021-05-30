// // ===== FOR LOOPS
// // for ([initialExpression]; [condition]; [incrementExpression])
// // for (let i = 1; i <= 10; i++) {
// //   console.log("HELLO:", i);
// // }

// // for (let num = 1; num <= 20; num++) {
// //   console.log(`${num}x${num} = ${num * num}`);
// // }

// for (let i = 200; i >= 0; i -= 25) {
//   console.log(i);
// }

// // INFINITE LOOPS (Don't run this)
// // for (let i = 20; i >= 0; i++){
// //  console.log(i);
// // }

// // FOR LOOPS & ARRAYS
// const animals = ["lions", "tigers", "bears"];
// for (let i = 0; i < animals.length; i++) {
//   console.log(i, animals[i]);
// }

// const myStudents = [
//   {
//     firstName: "Zeus",
//     grade: 86,
//   },
//   {
//     firstName: "Artemis",
//     grade: 97,
//   },
//   {
//     firstName: "Hera",
//     grade: 72,
//   },
//   {
//     firstName: "Apollo",
//     grade: 90,
//   },
// ];

// for (let i = 0; i < myStudents.length; i++) {
//   let student = myStudents[i];
//   console.log(`${student.firstName} scored ${student.grade}`);
// }

// // If looping in reverse i = variable.length - 1; i >= 0 ; i --
// const word = "stressed";
// for (let i = word.length - 1; i >= 0; i--) {
//   console.log(word[i]);
// }

// let sumOfGrades = 0;
// for (let i = 0; i < myStudents.length; i++) {
//   let student = myStudents[i];
//   sumOfGrades += student.grade;
// }

// console.log(sumOfGrades / myStudents.length);

// ======== NESTED LOOPS ======
// for (let i = 1; i <= 10; i++) {
//   console.log("OUTER LOOP:", i);
//   for (let j = 5; j >= 0; j -= 2) {
//     console.log("   INNER LOOP:", j);
//   }
// }

// const gameBoard = [
//   [4, 32, 8, 4],
//   [64, 8, 32, 2],
//   [8, 32, 16, 4],
//   [2, 8, 4, 2],
// ];

// let totalScore = 0;

// for (let i = 0; i < gameBoard.length; i++) {
//   let row = gameBoard[i];
//   for (let j = 0; j < row.length; j++) {
//     totalScore += row[j];
//   }
// }

// console.log(totalScore);

// ======= WHILE LOOP ====
// for (let i = 0; i <= 5; i++) {
//   console.log(i);
// }

// let j = 0;
// while (j <= 5) {
//   console.log(j);
//   j++;
// }

// const target = Math.floor(Math.random() * 10);
// let guess = "";

// while (guess !== target) {
//   guess = Math.floor(Math.random() * 10);
//   console.log(`Target: ${target} Guess: ${guess}`);
// }
// console.log("========");
// console.log("CONGRATS YOU WIN!");
// console.log("========");

// while (some condition)
//in the loop, update or attempt to make that condition false
//after the loop what should the program do

// ===== BREAK =====
// for (let i = 0; i < 10; i++) {
//   console.log(i);
//   if (i === 5) {
//     break;
//   }
// }

// const target = Math.floor(Math.random() * 10);
// let guess = Math.floor(Math.random() * 10);
// while (true) {
//   if (target === guess) break;
//   console.log(`Target: ${target} Guess: ${guess}`);
//   guess = Math.floor(Math.random() * 10);
// }

// console.log("========");
// console.log("CONGRATS YOU WIN!");
// console.log("========");

// ==== FOR...OF
let subreddits = ["soccer", "popheads", "cringe", "books"];

for (let i = 0; i < subreddits.length; i++) {
  console.log(subreddits[i]);
}

for (let sub of subreddits) {
  console.log(sub);
}

for (let char of "cocadoodledoo") {
  console.log(char.toUpperCase());
}
