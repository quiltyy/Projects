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

// ====== Push (returns the length of the array after addition)
topSongs.push("Fortunate Son");

// ====== Pop (returns value that was removed from array)
topSongs.pop();

// ====== Unshift (adds item to front of array and returns lengeth of array)
let dishesaToDo = ["big platter"];
dishesaToDo.unshift("large plate");
dishesaToDo.unshift("small plate");
dishesaToDo.unshift("cereal bowl");
dishesaToDo.unshift("mug");
dishesaToDo.unshift("dirty spoon");

// ====== Shift (removes item from front of list and returns item)
dishesaToDo.shift();

// ====== Concat
let fruits = ["apple", "banana"];
let veggies = ["asparagus", "brussel sprouts"];
let meats = ["steak", "chicken breast"];

console.log(fruits.concat(veggies));

let allFood = fruits.concat(veggies, meats);

// ======= Includes and IndexOf
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

// ======= Reverse
// (Changes the actual variable.)
let letters = ["T", "C", "E", "P", "S", "E", "R"];
letters.reverse();

// ======== Join - Combines all the values of an array into one string.
// Adding a value to the method inserts the value between each (Default is ,)
letters.join();
letters.join("&");

// ======= Slice
// Takes Portion of array and copy it into a new array
let animals = ["shark", "salmon", "whale", "bear", "lizard", "tortoise"];

// Selects from up to but no including the second index value
let swimmers = animals.slice(0, 3);
let mammals = animals.slice(2, 4);
let reptiles = animals.slice(4);
let quadrupeds = animals.slice(-3);
// can call animals.slice(); to copy the entire array
let copyOfAnimals = animals.slice();

//  ======== Splice - Remove or Replace an element.
// .splice(startIndex, deleteCount, itemsToInsert);
//et animals = ["shark", "salmon", "whale", "bear", "lizard", "tortoise"];

// Inserting w/ Splice
// At index 1, delete 0 items and insert octopus
animals.splice(1, 0, "octopus");

// Deleting w/ Splice
// At index 5, delete 2 items
animals.splice(3, 2);

// Replacing w/ Splice
// At index 3 delete 2 items and replace them with snake and frog
animals.splice(5);

// ========== Sort
// Updates and replaces the array with the changed order
let people = ["Mrs. Robinson", "Angie", "Jolene", "Maggie May", "Roxanne"];
people.sort();

// Covert everything to string then sort
// Is Not a Numeric Sort
let nums = [34, 10, 10000, 67, 99];
nums.sort();

// =====  Nested Arrays
const animalPairs = [
  ["doe", "buck"],
  ["ewe", "ram"],
  ["peaham", "peacock"],
];

consol.log(animalPair[2][0]); // Returns peaham
animalPairs[0][1] = "stag"; // Changes buck to stag
