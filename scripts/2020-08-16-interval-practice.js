let template = "How many half steps is the interval X?";
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

let check_answer = function(answer, question) {
	if(answer > questions.length) {
		return false;
	}
	let q = questions[answer];
	return question.includes(q);
};

let update_question = function() {
	let answer = questions[Math.floor(Math.random() * questions.length) 
        document.getElementById('question').value = q;
	return answer;
};

let q

let quiz = function() (
	
);

