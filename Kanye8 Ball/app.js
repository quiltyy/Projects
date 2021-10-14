async function getQuote() {
  const res = await axios.get("https://api.kanye.rest/");
  quote = res.data.quote;
  document.getElementById("kanye8").innerHTML = `${quote}`;
}

// getQuote().then((res) => {
//   quote = res.data.quote;
//   document.getElementById("quote").innerHTML = `${quote}`;
// });

window.onclick = reloadQuote;
function reloadQuote() {
  getQuote();
}
