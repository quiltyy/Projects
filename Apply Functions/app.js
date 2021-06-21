// === Array Callback Methods ===
// forEach
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
// filter
// find 
// reduce
//some
// every