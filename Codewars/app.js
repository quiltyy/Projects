// My Solution
function repeatStr(n, s) {
  let str = "";
  for (let i = 0; i < n; i++) {
    str += s;
  }
  return str;
}

// Best Solution
function repeatStr(n, s) {
  return s.repeat(n);
}
