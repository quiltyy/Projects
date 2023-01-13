const btn = document.querySelector('button');

btn.addEventListener('click', function () {
  alert('Clicked!!!')
});

btn.addEventListener('click', function () {
  console.group('Second Thing!!')
});

btn.addEventListener('mouseover', function () {
  btn.innerText = `Stop Touching Me!!`
});

btn.addEventListener('mouseout', function () {
  btn.innerText = 'Click Me!';
})

window.addEventListener('scroll', function () {
  console.log('Stop Scrolling!!');
})