// Creating an Object
const fitBitData = {
  totalSteps: 308727,
  totalMiles: 211.7,
  avgCalorieBurn: 5755,
  workoutsThisWeek: "5 of 7",
  avgGoodSleep: "2:13",
};

// ==== Accessing Object Properties

const palette = {
  red: "#eb4d4b",
  yellow: "#f9ca24",
  blue: "#30336b",
};

let mysteryColor = "yellow";

// ==== Adding and Updating Properties

const userReviews = {};
// Creating a new property with [ ] or .
userReviews["queenBee49"] = 4.0;
userReviews.mrSmith78 = 3.5;
// Changing a property
userReviews["queenBee49"] += 2;
console.log(userReviews);

// ===== Nested Arrays and Objects
const student = {
  firstName: "David",
  lastName: "Jones",
  strengths: ["Music", "Art"],
  exams: {
    midterm: 92,
    final: 88,
  },
};

const avg = (student.exams.midterm + student.exams.final) / 2;
const str = student.strengths[1];
console.log(avg);
console.log(str);

const shoppingCart = [
  {
    product: "Jenga Classic",
    price: 6.88,
    quantity: 1,
  },
  {
    product: "Echo Dot",
    price: 29.99,
    quantity: 3,
  },
  {
    product: "Fire Stick",
    price: 39.99,
    quantity: 2,
  },
];

const subTotal = shoppingCart[1].price * shoppingCart[1].quantity;
console.log(subTotal);

let nums = [1, 2, 3];
let mystery = [1, 2, 3];

num === mystery; // would return false
