// TODO
// Adjust font positioning based on response size so it fits in the 8 ball
// Disable highlighting on font
// Ensure compatability with different monitor / screen sizes
// Create 8 ball animation
// Adjust font and colors to more closely represent 8ball

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

const ball = document.querySelector("eight-ball");

document.addEventListener("dragend", function (event) {
  getQuote();
});
