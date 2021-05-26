// ===== FOR LOOPS
// for ([initialExpression]; [condition]; [incrementExpression])
// for (let i = 1; i <= 10; i++) {
//   console.log("HELLO:", i);
// }

// for (let num = 1; num <= 20; num++) {
//   console.log(`${num}x${num} = ${num * num}`);
// }

for (let i = 200; i >= 0; i -= 25) {
  console.log(i);
}

// INFINITE LOOPS (Don't run this)
// for (let i = 20; i >= 0; i++){
//  console.log(i);
// }

// FOR LOOPS & ARRAYS
const animals = ["lions", "tigers", "bears"];
for (let i = 0; i < animals.length; i++) {
  console.log(i, animals[i]);
}

const myStudents = [
  {
    firstName: "Zeus",
    grade: 86,
  },
  {
    firstName: "Artemis",
    grade: 97,
  },
  {
    firstName: "Hera",
    grade: 72,
  },
  {
    firstName: "Apollo",
    grade: 90,
  },
];

for (let i = 0; i < myStudents.length; i++) {
  let student = myStudents[i];
  console.log(`${student.firstName} scored ${student.grade}`);
}

// If looping in reverse i = variable.length - 1; i >= 0 ; i --
const word = "stressed";
for (let i = word.length - 1; i >= 0; i--) {
  console.log(word[i]);
}

let sumOfGrades = 0;
for (let i = 0; i < myStudents.length; i++) {
  let student = myStudents[i];
  sumOfGrades += student.grade;
}

console.log(sumOfGrades / myStudents.length);
