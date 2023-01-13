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
// Basically empty function alternative for single parameters

const square = function (x) {
    return x + x;
}
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

// some & every
// Booleans for checking if every or some elements contain x

const words = ["dog", "dig", "log", "bag", "wag"];

const all3Lets = words.every(word => words.every(word => word.length === 3)); // returns True
const lastLetter = words.every(word => {
    const last = word.length - 1;
    return word(last) === 'g'
})

const someStartwithD = words.some(word => word[0] === 'd');

// sort pt. 2
// Sort with compare to compare integers rather than strings

const prices = [400.50, 3000, 99.99, 35.99, 12.00, 9500];

prices.sort();

// Sort updates the original array rather than creating a new one
// can use slice() to create new array

const ascSort = prices.sort((a, b) => a - b);
const descSort = prices.sort((a, b) => b - a);

// reduce
// Executes a reducer function of each element of
// the array resulting in a single value

// summing an array using reduce
[3, 5, 7, 9, 11].reduce((sumOfElements, currentValue) => {
    return accumulator + currentValue;
})

const nums = [3, 4, 5, 6, 7];
nums.reduce((total, currentVal) => {
    return total * currentVal;
});

// find max using reduce
let grades = [89, 96, 58, 77, 62, 93, 81, 99, 73];

const topScore = grades.reduce((max, currVal) => {
    if (currVal > max) return currVal;
    return max;
})

topScore;

// Must have an initial value to compare in 
//reduce add at end of function

const sum = grades.reduce((sum, currVal) => {
    return sum + currVal
}, 0)

// Tallying
const votes = ['y', 'y', 'n', 'y', 'n', 'y', 'n', 'y', 'n', 'n', 'n', 'y', 'y'];

// const results = votes.reduce((tally, val) => {
//     if (tally[val]) {
//         tally[val]++
//     } else {
//         tally[val] = 1;
//     }
//     return tally
// }, {})

const results = votes.reduce((tally, val) => {
    tally(val) = (tally(val) || 0) + 1;
    return tally;
}, {})

