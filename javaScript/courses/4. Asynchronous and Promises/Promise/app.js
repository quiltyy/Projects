const fakeRequest = (url) => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const pages = {
                '/users': [{
                        id: 1,
                        username: 'Bilbo'
                    },
                    {
                        id: 5,
                        username: 'Esmerleda'
                    }
                ],
                '/about/': 'This is the about page!'
            };
            const data = pages[url]
            if (data) {
                resolve({
                    status: 200,
                    data
                });
            } else {
                reject({
                    status: 404
                });
            }
        }, 1000);
    })
};

fakeRequest('/users')
    .then((res) => {
        console.log('Status Code:', res.status)
        console.log('Data: ', res.data)
        console.log("Request Worked");
    })
    .catch((res) => {
        console.log(res.status)
        console.log('Request Failed')
    });

fakeRequest('/dogs')
    .then((res) => {
        console.log('Status Code:', res.status)
        console.log('Data: ', res.data)
        console.log("Request Worked");
    }).catch((res) => {
        console.log(res.status)
        console.log('Request Failed')
    });