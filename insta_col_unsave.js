function goNext() {
  document.querySelector('[aria-label="Next"]').parentElement.click()
  setTimeout(unsave, 1000);
}

const sleep = function(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function unsave() {
  document.querySelector('[aria-label="Remove"]').parentElement.click()
  col = document.getElementsByClassName("_a9-- _ap36 _a9-_")
  sleep(500).then(()=>col[1].click())
  setTimeout(goNext, 1000)
}

unsave()
