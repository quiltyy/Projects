// TODO
// Adjust font positioning based on response size so it fits in the 8 ball.
// -- Check quote for length before outputting. If length > x pull again
// Ensure compatability with different monitor / screen sizes
// Create 8 ball animation
// -- Kanye kicking 8ball animation.
// Adjust colors to more closely represent 8ball
// Capitalize all of the letters in the response

async function getQuote() {
  try {
    const res = await axios.get("https://api.kanye.rest/");
    quote = res.data.quote.toUpperCase();
    // upper = quote.toUpperCase();
    document.getElementById("kanye8").innerHTML = `"${quote}"`;
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
