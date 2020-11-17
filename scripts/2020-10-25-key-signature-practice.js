let key    = "C";
const keys = ["Ab", "A", "Bb", "B", "Cb", "C", "C#", "Db", "D", "Eb", "E", "F", "F#", "Gb", "G"];
const answerEl   = document.getElementById('answer');
const resultEl   = document.getElementById('result');
const clefEl     = document.getElementById('clef');
const keyTypeEl  = document.getElementById('keytype');

function checkAnswer() {
    const answer = answerEl.value;
    answer[0] = answer[0].toUpperCase();
    return answer === key;
}

function wrongAnswerIndicator() {
    answerEl.style.borderColor = "red";
    resultEl.innerHTML         = "Incorrect";
    resultEl.style.color       = "red";
}

function resetAnswerBox() {
    answerEl.style.borderColor = "";
}

function quiz() {
    if (checkAnswer()) {
        resultEl.innerHTML   = "Correct!";
        resultEl.style.color = "";
        update();
    } else {
        wrongAnswerIndicator();
    }
}

function newKey() {
    let newKey = key;
    while (newKey === key) {
        newKey = keys[Math.floor(Math.random() * keys.length)];
    }
    key = newKey;
    renderKey(key, keyTypeEl.value, clefEl.value, false);
}

function renderKey(key, ktype, clef, consolelog) {
    const abc  = `X: 1
L: 1/1
K: ${key}${ktype} ${clef}
|]`;
    if (consolelog) {
        console.log(abc);
    }
    ABCJS.renderAbc("paper", abc);
}

function update() {
    resetAnswerBox();
    newKey();
}

update();
