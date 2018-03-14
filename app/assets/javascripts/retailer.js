// Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/



// Allocate Event Hanler

// select allocate and remove makers
document.onreadystatechange  = function()  {
	const allocate_buttons = document.getElementsByClassName('allocate');
	for (let button of allocate_buttons) allocate_event(button,button.id);

	const remove_buttons = document.getElementsByClassName('remove');
	for (let button of remove_buttons) remove_event(button,button.id);
};


const allocate_event = function(e,id) { e.addEventListener('click', function update() {

let xhr = new XMLHttpRequest();

let parent = document.getElementById(e.parentNode.parentNode.id); 	

xhr.open('PUT',`http://localhost:3000/makers/${id}/?r=${parent.id}`,true);
let csrf =  document.getElementsByTagName('meta')[1].getAttribute('content');
xhr.setRequestHeader('X-CSRF-Token', csrf);
xhr.send();

xhr.onreadystatechange = function()   {
if (xhr.readyState == 2 && xhr.status == 204) {	
let maker = document.getElementById(id);
remove_event(e,id);
// e.removeEventListener('click',update,true);


// let fi = parent.childNodes[1].childNodes[3];
for (let i =0; i < parent.children.length; i++ ) {
	if (parent.children[i].children[1].getAttribute('class') === 'remove') {
	let fi = parent.children[i].children[1];
	fi.classList.add('allocate');
	fi.classList.remove('remove');
    fi.innerHTML = "Allocate";
    e.addEventListener('click',update,true);

	}
}
maker.classList.remove('allocate');
maker.classList.add('remove');
maker.innerHTML = "Remove";
 }
}

},true )};





// Remove event handler

const remove_event = function(e,id) { e.addEventListener('click', function remove(event) {
let xhr = new XMLHttpRequest();
let parent = document.getElementById(e.parentNode.parentNode.id); 	
xhr.open('PUT',`http://localhost:3000/makers/3604/?r=${parent.id}`,true);
let csrf =  document.getElementsByTagName('meta')[1].getAttribute('content');
xhr.setRequestHeader('X-CSRF-Token', csrf);
xhr.send();
xhr.onreadystatechange = function()  {
if (xhr.readyState == 2 && xhr.status == 204) {	
let maker = document.getElementById(id);
maker.classList.remove('remove');
maker.classList.add('allocate');
maker.innerHTML = "Allocate";
allocate_event(e,id);

 }
}
},true)};


