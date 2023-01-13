async function greet() {
  return "Hello!!";
}

greet().then((val) => {
  console.log("Promise Resolved With: ", val);
});

async function add(x, y) {
  if (typeof x !== "number") || typeof y !== 'number') {
    throw 'X and Y must be numbers!'
  }
    return x + y;
}

add(6, 7).then((val) => {
  console.log('Promise Resolved With: ', val)
})
  .catch((err) => {
    console.log('Promise Rejected With: ', err)
  });