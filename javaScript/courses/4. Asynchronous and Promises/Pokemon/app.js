// SEQUENTIAL REQUEST
// async function get3Pokemon() {
//   const poke1 = await axios.get("https://pokeapi.co/api/v2/pokemon/1");
//   const poke2 = await axios.get("https://pokeapi.co/api/v2/pokemon/2");
//   const poke3 = await axios.get("https://pokeapi.co/api/v2/pokemon/3");
//   console.log(poke1.data.name);
//   console.log(poke2.data.name);
//   console.log(poke3.data.name);
// }

// PARRALEL REQUEST
async function get3Pokemon() {
  try {
    const prom1 = axios.get("https://pokeapi.co/api/v2/pokemon/1");
    const prom2 = axios.get("https://pokeapi.co/api/v2/pokemon/2");
    const prom3 = axios.get("https://pokeapi.co/api/v2/pokemon/3");
    const results = await Promise.all([prom1, prom2, prom3]);
    printPokemon(results);
  } catch (err) {
    console.log("Caught Error: ", err);
  }
}

function printPokemon(results) {
  for (let pokemon of results) {
    console.log(pokemon.data.name);
  }
}

get3Pokemon();
