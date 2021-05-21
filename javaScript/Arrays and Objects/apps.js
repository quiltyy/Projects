// Create an array
let colors = ["blue", "red", "yellow", "green"];

// Create an empty array
let empty = [];

// Last item of an array
console.log(colors[colors.length - 1]);

// Change the value of an array at the index given
colors[1] = "torquoise";

console.log(colors[1]);

let topSongs = [
  "First Time Ever I Saw Your Face",
  "God Only Knows",
  "A Day In the Life",
  "Life on Mars",
];

// Push (returns the length of the array after addition)
topSongs.push("Fortunate Son");

// Pop (returns value that was removed from array)
topSongs.pop();

// Unshift (adds item to front of array and returns lengeth of array)
let dishesaToDo = ["big platter"];
dishesaToDo.unshift("large plate");
dishesaToDo.unshift("small plate");
dishesaToDo.unshift("cereal bowl");
dishesaToDo.unshift("mug");
dishesaToDo.unshift("dirty spoon");

// Shift (removes item from front of list and returns item)
dishesaToDo.shift();

// Concat
let fruits = ["apple", "banana"];
let veggies = ["asparagus", "brussel sprouts"];
let meats = ["steak", "chicken breast"];

console.log(fruits.concat(veggies));

let allFood = fruits.concat(veggies, meats);

//Includes and IndexOf
let ingredients = [
  "water",
  "corn starch",
  "flour",
  "cheese",
  "brown sugar",
  "shrimp",
  "eel",
  "butter",
];

ingredients.includes("fish");
if (ingredients.inclueds("water")) ingredients.indexOf("cheese");
