// === Array Callback Methods ===
// forEach
// iterates over an array and returns a value for each item in the array
const nums = [9, 8, 7, 6, 5, 4, 3, 2, 1];
nums.forEach(function (n) {
    console.log(n + n)
});

nums.forEach(function (el) {
    if (el % 2 === 0) {
        console.log(el)
    }
})

nums.forEach(function (num, idx) {
    console.log(idx, num);
})


// map
// iterates over an array and creats a new array after whatever functions are performed
const texts = ['rofl', 'lol', 'omg', 'ttyl'];
const caps = text.map(function (t) {
    return t.toUppercase();
})
console.log(caps);

const numbers = [20, 21, 22, 23, 24, 25, 26];
const doubles = numbers.map(function (num) {
    num * 2;
})
console.log(doubles);

const numDetail = numbers.map(function (n) {
    return {
        value: n,
        isEven: n % 2 === 0
    }
})
console.log(numDetail)

const words = ['asap', 'byob', 'rsvp', 'diy'];
const abbrevs = words.map(function (word) {
    return word.toUpperCase().split('').join('.')
})

// Arrow Functions
//Basically empty function alternative for single parameters

// const square = function (x) {
//     return x + x;
// }
// Same thing as: 
const square = (x) => {
    return x * x;
}

// If only one parameter you don't need parenthesis 

const square = x => {
    return x * x;
}

// Implicit return
// If there is only one expression to be returned you don't need parenthesis or return
const addition = n => n + n

// filter
// Creates a new array with all elements that pass the test 
const nums = [9, 8, 7, 6, 5, 4, 3, 2, 1];
const odds = nums.filter(n => {
    return n % 2 === 1;
})
const evens = nums.filter(n => {
    return n % 2 === 0;
})



// find 
// Returns first object found then stops running.

let movies = [
    "The Fantastic Mr. Fox",
    "Mr. and Mrs. Smith",
    "Mrs. Doubtfire",
    "Mr. Deeds"
]

let movie = movies.find(movie => {
    return movie.includes('Mrs.')
})

let movie2 = movies.find(m => m.indexOf('Mrs') === 0);

// reduce
// some
// every