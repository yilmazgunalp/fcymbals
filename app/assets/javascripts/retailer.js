// Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

const url_d = "http://localhost:3000";
const url_p = "https://fcymbals.herokuapp.com"



// select allocate and remove buttons
window.onload  = function init()  {
	const allocate_buttons = document.getElementsByClassName('allocate');
	for (let button of allocate_buttons) button.addEventListener("click",allocate);
	const remove_buttons = document.getElementsByClassName('remove');
	for (let button of remove_buttons) button.addEventListener("click",remove);
};

// Allocate Event Hanler
const allocate = () => {
	let button = event.target; 
	let xhr = makeAjaxRequest(button.id,button.parentNode.parentNode.id);
	xhr.onreadystatechange = function()   {
		if (xhr.readyState == 2 && xhr.status == 204) {	
			console.log("Allocated..");
			toggleClass(button);
			updateSiblings(button);
		}
	}
}

// Remove event handler
const remove = () => {
	let button = event.target; 
	let xhr = makeAjaxRequest(3604,button.parentNode.parentNode.id);
	xhr.onreadystatechange = function()   {
		if (xhr.readyState == 2 && xhr.status == 204) {	
			console.log("Removed..");
			toggleClass(button);
		}
	}
}

const makeAjaxRequest = (maker_id,retailer_id) => {
	let xhr = new XMLHttpRequest();
	xhr.open('PUT',`${url_p}/makers/${maker_id}/?r=${retailer_id}`,true);
	let csrf =  document.getElementsByTagName('meta')[1].getAttribute('content');
	xhr.setRequestHeader('X-CSRF-Token', csrf);
	xhr.send();	
	return xhr;
}


const toggleClass =  (button) => {
		if (button.className == "allocate") {
			button.classList.remove('allocate');
			button.classList.add('remove');
			button.innerHTML = "Remove";
			button.removeEventListener("click",allocate);
			button.addEventListener("click",remove);
			return;	
		}
		if (button.className == "remove") {
			button.classList.remove('remove');
			button.classList.add('allocate');
			button.innerHTML = "Allocate";
			button.removeEventListener("click",remove);	
			button.addEventListener("click",allocate);
			return;
		}
}

const updateSiblings = (button) => {
	if (button.className == "remove") {
		let parent = button.parentNode.parentNode
		let targetButton = Array.from(parent.querySelectorAll(`button.remove`)).
		filter(elm => elm.id != button.id);
		if (targetButton[0]) toggleClass(targetButton[0]);
		return;
	}
}
