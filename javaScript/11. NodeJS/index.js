#!/usr/bin/env node

const fs = require("fs");

// METHOD 2
// const util = require("util");
// const lstat = until.promisify(fs.lstat);

// METHOD 3
const { lstat } = fs.promises;

fs.readdir(process.cwd(), (err, filenames) => {
  if (err) {
    // error handling code here
    console.log(err);
  }
});

// METHOD 1
// const lstat = (filename) => {
//   return new Promise((resolve, reject) => {
//     fs.lstat(filename, (err, stats) => {
//       if (err) {
//         reject(err);
//       }
//       resolve(stats);
//     });
//   });
// };
