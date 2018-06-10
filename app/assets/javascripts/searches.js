const url_d = "http://localhost:3000";
const url_p = "http://www.redcymbal.net"

const parser = new DOMParser();
const template = parser.parseFromString(`<div class="result googlify">
    <h1 class="result-header">
        <ul class="result-header-ul">
            <li class="merchant"> <span class="address"></span></li>
            <li class="price"><span class="currency">AUD</span></li>
        </ul>
    </h1>
    <div class="product-details">
         <div class="product-img-wrapper"> <img src="logo.png" alt="" class="product-img"> </div>
          <p class="product-info"> <a href="" target="blank"></a> </p> 
        
    </div>
</div>`,'text/html').querySelector("div.result");


window.onload = () => {

let searchBox = document.querySelector("input[type='search']");

searchBox.addEventListener("focus", qfocus)

if (getUrlParam("q"))  searchBox.value = decodeURI(getUrlParam("q")).replace(/\+/g," ");
 
}


function qfocus(event) {
	let value = event.target.value;
	if(value == "find your sound..") event.target.value = "";
	
}


// thanks to https://html-online.com/articles/get-url-parameters-javascript/ 
function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function getUrlParam(parameter, defaultvalue){
    var urlparameter = defaultvalue;
    if(window.location.href.indexOf(parameter) > -1){
        urlparameter = getUrlVars()[parameter];
        }
    return urlparameter;
}


function getFacets(ids) {
   event.preventDefault();
   let xhr = new XMLHttpRequest();
   xhr.open('GET',`${url_p}/searches/getfacets?makers=${ids}`,true);
   let csrf =  document.getElementsByTagName('meta')[1].getAttribute('content');
    xhr.setRequestHeader('X-CSRF-Token', csrf);
    xhr.setRequestHeader('Accept', 'application/json');

    xhr.send();

    xhr.onreadystatechange = function()   {
        if (this.readyState == 4 && this.status == 200) { 
            createResults(JSON.parse(this.response));
            
        }
    }
}


function createResults(list) {
let container = document.querySelector("div.results-container")
let newContainer = container.cloneNode();

for (elm of list) {
   let temp = template.cloneNode(true);
   
   temp.querySelector("li.merchant").innerText = elm[0];
   let price = document.createTextNode(elm[2]);
   temp.querySelector("li.price").appendChild(price);
   temp.querySelector("a").innerText = elm[1];

   newContainer.appendChild(temp);
   }
container.remove();

document.querySelector("main").appendChild(newContainer);
}


