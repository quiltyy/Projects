const willGetYouADog = new Promise((resolve, reject) => {
    const rand = Math.random();
    if (rand < 0.5) {
        resolve();
    } else {
        reject();
    }
});

willGetYouADog.then(() => {
    console.log('Yay We Got a Dog!!!');
});

willGetYouADog.catch(() => {
    console.log('No Dog');
})