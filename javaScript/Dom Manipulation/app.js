// // HEAD
// const form = document.querySelector('form')

// form.innerHTML

// const ul = document.querySelector('ul')

// ul.innerText

// ul.innerHTML

// const h1 = document.querySelector9('h1');

// const input = document.querySelectorAll('input')

// inputs[0].value
// inpust[1].value
// inputs[2].checked
// input[1].placeholder = ' '

// const a = document.querySelector('a')

// a.href

// const img = document.querySelector('img')
// img.src
// // =======
// const sheet = new CSSStyleSheet();
// sheet.replaceSync('*  {transition: all 2s}');
// // Have to change an Element to ID "viewport"

// document.adoptedStyleSheets = [sheet];

// const allElls = document.getElementById("viewport").children;

// setInterval(() => {
//     for (let el of allElls) {
//         const rotation = Math.floor(Math.random() * 360);
//         const x = Math.floor(document.body.clientWidth * Math.random())
//         const y = Math.floor(document.body.clientHeight * Math.random())
//         el.style.transform = `translate(${x}px, ${y}px) rotate(${rotation}deg`;
//     }
// }, 2000)

const allLis = document.querySelectorAll('li');

// for (let i = 0; i < allLis.length; i++) {
//     console.log(allLis[i].innerText);
// }

for (let li of allLis) {
    li.innerHTML = 'WE ARE <b>THE CHAMBERLAINS</b>'
}