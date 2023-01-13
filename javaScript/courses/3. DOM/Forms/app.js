// Query selector variables for later 
const creditCardInput = document.querySelector("#cc")
const termsCheckbox = document.querySelector("#terms")
const veggieSelector = document.querySelector("#veggie")

// Array for formData.
const formData = {};

// Create index for formData based on NAME in HTML then fill in with events from page.  
// This function will update the values for all inputs on a form without having to create a new function for each listener. 
for (let input of [creditCardInput, termsCheckbox, veggieSelect]) {
    input.addEventListener('input', ({ // INPUT updates as each character is added  CHANGE  updates after submit.
        target
    }) => {
        const {
            name,
            type,
            value,
            checked
        } = target;
        formData[name] = type === 'checkox' ? checked : value;
    });
}

// Same thing as above in long form.

// creditCardInput.addEventListener('input', (e) => {
//     console.log("CC Changed", e);
//     formData['cc'] = e.target.value;
// });

// veggieSelector.addEventListener('input', (e) => {
//     console.log("Veggie Changed", e);
//     formData['veggie'] = e.target.value;
// });

// termsCheckbox.addEventListener('input', (e) => {
//     console.log("Checkbox", e);
//     formData['agreeToTerms'] = e.target.checked;
// });