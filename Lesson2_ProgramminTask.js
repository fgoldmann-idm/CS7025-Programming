// This is a test file for JavaScript variables and arrays
// Declaring a set of variables 
let myname = "My name is Finn";
var ArrayTest = [1, 2, 3, 4, 5];   
let replacable = 10
var playerScore = 0

// changing the value of the replacable variable
replacable = 20

// function to add 1 to the playerScore variable
function addOnetoScore() {
    playerScore += 1;
}

// printing the variables to the console
console.log(myname);
console.log(ArrayTest);
console.log(replacable);

// iterating through the playerScore until it reaches 10
while (playerScore < 10) {
    addOnetoScore();
    console.log(playerScore);
}

// checking if the playerScore is odd or even
let isOddorEven = (playerScore) => {
    if (playerScore % 2 === 0) {
        return "Even";
    } else {
        return "Odd";
    }
}

console.log(isOddorEven(playerScore));
