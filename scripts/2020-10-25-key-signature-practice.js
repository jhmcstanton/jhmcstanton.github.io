var key="C",keys=["Ab","A","Bb","B","Cb","C","C#","Db","D","Eb","E","F","F#","Gb","G"],answerEl=document.getElementById('answer'),resultEl=document.getElementById('result'),clefEl=document.getElementById('clef'),keyTypeEl=document.getElementById('keytype');function checkAnswer(){var answer=answerEl.value;answer[0]=answer[0].toUpperCase();return answer===key}
function wrongAnswerIndicator(){answerEl.style.borderColor="red";resultEl.innerHTML="Incorrect";resultEl.style.color="red"}
function resetAnswerBox(){answerEl.style.borderColor=""}
function quiz(){if(checkAnswer()){resultEl.innerHTML="Correct!";resultEl.style.color="";update()}else wrongAnswerIndicator()}
function newKey(){var newKey=key;while(newKey===key)newKey=keys[Math.floor(Math.random()*keys.length)];key=newKey;renderKey(key,keyTypeEl.value,clefEl.value,false)}
function renderKey(key,ktype,clef,consolelog){var abc="X: 1\nL: 1/1\nK: "+key+ktype+" "+clef+"\n|]";if(consolelog)console.log(abc);ABCJS.renderAbc("paper",abc)}
function update(){resetAnswerBox();newKey()};update()