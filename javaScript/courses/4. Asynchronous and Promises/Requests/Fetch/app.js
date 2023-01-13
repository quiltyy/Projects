const checkStatusandParse = (response) => {
    if (!response.ok)
        throw new Error(`Status Code Error: ${response.status}`);
    return response.json()
};

const printPlanets = (data) => {
    for (let planet of data.results) {
        console.log(planet.name)
    }
    return Promise.resolve(data.next);
}

const fetchPlanets = (url = 'https://swapi.dev/api/planets/') => {
    return fetch(url);
}

fetchPlanets()
    .then(checkStatusandParse)
    .then(printPlanets)
    .then(fetchPlanets)
    .then(checkStatusandParse)
    .then(printPlanets)
    .then(fetchPlanets)
    .then(checkStatusandParse)
    .then(printPlanets)
    .then(fetchPlanets)
    .then(checkStatusandParse)
    .then(printPlanets)
    .then(fetchPlanets)
    .then(checkStatusandParse)
    .then(printPlanets)
    .then(fetchPlanets)

    .catch((err) => {
        console.log('Something went wrong');
        console.log(err);
    })