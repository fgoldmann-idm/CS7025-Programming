const weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=53.5507&longitude=9.993&hourly=temperature_2m,precipitation_probability,cloud_cover";

fetch(weatherURL) //put the const in the parantheses to pass arguments to the function
//.then((response)... transfers the data into a convertible json format
.then ((response) => {
	return response.json();
})
//.then((data)... turns/converts the data into a text to put it into the content and to update it afterwards
.then((data) => {
	//textContent = data.latitude is updating the text onced it founds the value. textContent is the text value of the element; = assigns a new value to the element; data.latitude reads the data from the id.
	document.getElementById("latitude").textContent = data.latitude; 
	document.getElementById("longitude").textContent = data.longitude;
	document.getElementById("rain_probability").textContent = data.hourly.precipitation_probability[0];
	document.getElementById("temperature").textContent = data.hourly.temperature_2m[0];
})
//if the previous code cannot be exectued an error occurs and will be printed in the console
.catch((err) => {
	console.log(err);
});