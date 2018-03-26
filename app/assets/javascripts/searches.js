
window.onload = () => {

let searchBox = document.querySelector("input[type='search']");

searchBox.addEventListener("focus", (e) => e.target.value = null)

searchBox.addEventListener("blur", (e) => e.target.value = "find your sound..")









}