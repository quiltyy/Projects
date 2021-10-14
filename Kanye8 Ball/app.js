axios.get("https://api.kanye.rest/").then((response) => {
  quote = response.data.quote;
  document.getElementById("quote").innerHTML = `${quote}`;
});
