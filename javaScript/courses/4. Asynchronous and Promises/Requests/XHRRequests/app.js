// Create object for request
const firstReq = new XMLHttpRequest();

// Callbacks
firstReq.addEventListener('load', function () {
    console.log("FIRST REQUEST WORKED");
    const data = JSON.parse(this.responseText);
    const filmURL = data.results[0].films[0]
    const filmReq = new XMLHttpRequest();
    filmReq.addEventListener('load', function () {
        console.log("SECOND REQUEST WORKED")
        const filmData = JSON.parse(this.responseText)
        console.log(filmData.title)
    })
    filmReq.addEventListener('error', function (e) {
        console.log("Error!!", e);
    })
    filmReq.open('GET', filmURL);
    filmReq.send();
});


firstReq.addEventListener('error', () => {
    console.log("ERROR!!")
})

// Type of Request and Where
firstReq.open("GET", "https://swapi.dev/api/planets/");

// Sending Request
firstReq.send();
console.log("Request Sent!");