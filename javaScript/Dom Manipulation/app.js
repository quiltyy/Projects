const sheet = new CSSStyleSheet();
sheet.replaceSync('*  {transition: all 2s}');
// Have to change an Element to ID "viewport"

document.adoptedStyleSheets = [sheet];

const allElls = document.getElementById("viewport").children;

setInterval(() => {
    for (let el of allElls) {
        const rotation = Math.floor(Math.random() * 360);
        const x = Math.floor(document.body.clientWidth * Math.random())
        const y = Math.floor(document.body.clientHeight * Math.random())
        el.style.transform = `translate(${x}px, ${y}px) rotate(${rotation}deg`;
    }
}, 2000)