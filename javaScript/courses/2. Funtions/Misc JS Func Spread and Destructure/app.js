// Default Parameters

function multiply(a, b = 1) {
  return a * b;
}

multiply(4); // 4
multiply(4, 5) // 20 

// Spread ... 
// Expands iterables

//Spread for Functions

const nums = [45, 23, 34, 7, 5]

Math.max(nums)
// NaN
Math.max(...nums)
//45

// Spread for Array Literals
const cephalopods = ['dumbo octopus', 'humboldt squid', 'flamboyant cuttlefish'];
const gastropods = ['giant african snail', 'banana slug', 'variable neon slug'];
const cnidaria = ['fire coral', 'noon jelly'];

const mollusca = [...cephalopods, ...gastropods]
const inverts = [...cephalopods, ...gastropods, cephalopods];

// Spread in Object Literals
// Can't spread an onject into an array
const feline = {
  legs: 4,
  family: 'Felidae'
};

const canine = {
  family: 'Canine',
  furry: true
};

const dog = {
  ...canine,
  isPet: true,
  adorable: true
}

const houseCat = {
  ...feline,
  isGrumpy: true,
  personality: 'unpredictable'
}

// Rest 
function sum(...nums) {
  return nums.reduce((total, currVal) => {
    return total + currVal
  })
}

const multiply = (...nums) => {
  nums.reduce((total, currVal) => total * currVal)
}

// Destructuring Arrays
const raceResults = [
  'Eliud Kipchoge',
  'Feyisa Lelisa',
  'Galen Rupp',
  'Ghirmay Ghebreslassie',
  'Alphonce Simbu',
  'Jared Ward'
];

// const gold = raceResults[0]
// const silver = raceResults[1]
// const bronze = raceResults[2]

const [gold, silver, bronze] = raceResults;
const [first, , , fourth] = raceResults;

// Destructuring Objects

const runner = {
  first: "Eliud",
  last: "Kipchonge",
  country: "Kenya",
  title: "Elder of the Order of the Golden Heart of Kenya"
}

const {
  first,
  last
} = runner;
const {
  country: nations
} = runner;

// Nested Destructuring

const results = [{
    first: "Eliud",
    last: "Kipchoge",
    country: "Kenya",
  },
  {
    first: "Feyisa",
    last: "Lilesa",
    country: "Ethiopia",
  },
  {
    first: "Galen",
    last: "Rupp",
    country: "United States",
  }
]

const [, {
  country
}] = results;

// Destructuring Parameters

function print({
  first,
  last,
  title
}) {
  console.log(`${first} ${last}, ${title}`)
}

const response = [
  'HTTP/1.1',
  '200 OK',
  'application/json',
]

function parseResponse([protocol, statusCode, contentType]) {
  console.log(`Status: $(statusCode)`)
}