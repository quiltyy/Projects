1 <= 4 && "a" === "a"; // true
9 > 10 && 9 >= 9; // false

let password = "chickenGal";

if (password.length >= 8 && password.indexOf(" ") === -1) {
  console.log("Valid Password");
} else {
  console.log("Invalid Password");
}

1 !== 1 || 10 === 10; // true
1 === 2 || 2 === 3; // false

let age = 76;

if (age < 6 || age >= 65) {
  console.log("Valid");
} else {
  console.log("Invalid");
}
