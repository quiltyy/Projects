axios.get("https://swapi.dev/api/planets/").then(({ data }) => {
  console.log(data);
  for (let planet of data.results) {
    console.log(planet.name);
  }
  axios
    .get(data.next)
    .then(({ data }) => {
      console.log(data);
      for (let planet of data.results) {
        console.log(planet.name);
      }
    })
    .catch((err) => {
      console.log("ERROR!!", err);
    });
});
