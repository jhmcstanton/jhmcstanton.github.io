let questions = [
	"unison",
	"minor 2nd",
	"major 2nd",
	"minor 3rd",
	"major 3rd",
	"perfect 4th",
	"diminished 5th",
	"perfect 5th",
	"minor 6th",
	"major 6th",
	"minor 7th",
	"major 7th",
	"perfect 8th"
];

let checkAnswer = function(answer, question) {
    if(answer >= questions.length) {
        return false;
    }
    let q = questions[answer];
    return question.includes(q);
};

let updateQuestion = function() {
    let question = questions[Math.floor(Math.random() * questions.length)];
    document.getElementById('question').innerHTML = `How many half steps are in the ${question}?`;
    return question;
};

let question = updateQuestion();

let quiz = function() {
    let resultTag = document.getElementById('result');
    let userAnswer = parseInt(document.getElementById('answer').value);
    if(checkAnswer(userAnswer, question)) {
        resultTag.innerHTML = "Correct!";
        question = updateQuestion();
    } else {
        resultTag.innerHTML = "Incorrect, try again!";
    }
};
