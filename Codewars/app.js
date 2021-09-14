// ====== CHECK IF NUMBER EVEN OR ODD
function even_or_odd(number) {  
  return number % 2 === 0 ? "even" : "odd";
}

// ====== CHECK STRING FOR CERTAIN LETTERS
function getCount(str) {
  var vowelsCount = 0;
  var vowels = ["a","e","i","o","u"];
  for(var i = 0;i < str.length;i++){
    for(var j=0;j<vowels.length;j++){
      if(str[i] === vowels[j]){
        vowelsCount++;
      }
    }
  }
  return vowelsCount;
}

// ====== CONVERT NUMBERS TO STRING
function numberToString(num) {
    return num.toString();
  }

// ====== REMOVE SPACES FROM STRING
function noSpace(x){
    combine = x.split(' ').join('');
    return combine
  }

// ====== GET RANDOM INTEGER
function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

// ====== RUN FUNCTION X TIMES
function deal(size) {
  for (let i = 0; i <= size - 1; i++) {
    getCard();
  }
}

// ====== DOUBLE AN ARRAY
function doubleArr(arr) {
  const result = [];
  for (let num of arr) {
    let double = num * 2;
    result.push(double);
  }
  return result;
}

// ====== REVERSE WORDS IN A STRING BUT NOT ORDER
function reverseWords(str) {
  // Go for it
  const final = [];
  for (let word of str.split(" ")) {
    final.push(word.split("").reverse().join(""));
  }
  return final.join(" ");
}


function nbYear(p0, percent, aug, p) {
    let i = 0;
    percent = percent / 100;
    console.log(percent);
    while (p0 < p) {
      p0 += p0 * percent + aug;
      i++
    }
    return i

    // your code
  }


// ======= IS THE INTEGER A SQUARE
var isSquare = x => {
    return Math.sqrt(x) % 1 === 0
}

isSquare(9)

var convertCNY = usd => { 
return `${(usd * 6.75).toFixed(2)} Chinese Yuan`;
}