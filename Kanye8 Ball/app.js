// TODO
// Create 8 ball animation
// delay reloadQuote to line up with animation so it doesn't instantly full in

async function getQuote() {
  try {
    const res = await axios.get("https://api.kanye.rest/");
    quote = res.data.quote;
    document.getElementById("kanye8").innerHTML = `${quote}`;
  } catch (err) {
    console.log("Error caught:", err);
  }
}

// window.onclick = reloadQuote;
// function reloadQuote() {
//   getQuote();
// }

window.addEventListener("dragend", getQuote);
