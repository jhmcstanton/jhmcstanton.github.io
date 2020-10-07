let count           = 4;
let beatType        = 4;
let tempo           = "60";
let defaultL        = "1/16";
let measuresPerLine = 2;
let beats           = [{pattern:"c2c2", chord:"C"}, {pattern: "c3c", chord: "C"}, {pattern: "ccc2", chord:"D"}, {pattern:"c2cw", chord: "D"}];
// Audio control options
let audioEnabled    = false;
let displayOptions  = {
    displayLoop     : true,
    displayRestart  : true,
    displayPlay     : true,
    displayProgress : true,
    displayWarp     : true
};
let audioOptions   = {
    chordsOff: false
};

let blockPatterns = [
    "c4", "c2c2", "cccc", "c2cc", "ccc2", "c3c", "cc3"
];

let blocksSection   = document.getElementById("blocks");
for (let i=0; i < blockPatterns.length; i++) {
    let pattern = blockPatterns[i];
    let abc = `X:${i+2}
L: ${defaultL}
K: C treble style=rhythm
${pattern}`;
    let blockId   = `block-${i}`;
    let blockHtml = `<div class="block">
<div id="${blockId}" onclick="append(${i})()"></div>
<label>Leading tie <input type="checkbox" id="${blockId}-tie"></label>
</div>`;
    blocksSection.innerHTML += blockHtml;
    ABCJS.renderAbc(blockId, abc);
}

let eventCallback = function(ev) {
    document.querySelectorAll('.cursor-note').forEach((el) => el.classList.remove('cursor-note'));
    let elements = ev['elements'].forEach((el) => el[0].classList.add('cursor-note'));
};

let updateMidi = function(tune) {
    if (!document.getElementById("audioEnabled").checked) {
        document.getElementById("audio").innerHTML = "";
        return;
    }
    if (ABCJS.synth.supportsAudio()) {
        let synthControl = new ABCJS.synth.SynthController();
        synthControl.load("#audio", { onEvent: eventCallback }, displayOptions);
    } else {
        document.getElementById("audio").innerHTML = "Audio not supported in this browser";
        return;
    }
    let synth = new ABCJS.synth.CreateSynth();
    synth.init({ visualObj: tune }).then(() => {
        synthControl.setTune(tune, false, audioOptions)
            .then(() => console.log("Audio loaded"))
            .catch((error) => console.warn("Audio problem: ", error));
    }).catch((error) => console.warn("Audio problem during init: ", error));
};

let clearScore = function() {
    beats.length = 0;
    update();
};

let removeLastBeat = function() {
    beats.pop();
    update();
};

let appendHelper = function(pattern, useTie, chord) {
    if (useTie) {
        pattern = "-" + pattern;
    }
    let beat = {pattern: pattern, chord: chord };
    beats.push(beat);
    update();
};

let append = function(i) {
    return function() {
        let pattern = blockPatterns[i];
        let useTie  = document.getElementById(`block-${i}-tie`).checked;
        let chord   = getChord();
        appendHelper(pattern, useTie, chord);
    };
};

let getCount = function() {
    return parseInt(document.getElementById("beatsPerMeasure").value);
};

let getChord = function() {
    return document.getElementById('nextChord').value;
};

let buildAbc = function() {
    let title    = document.getElementById("title").value;
    let composer = document.getElementById("composer").value;
    let count    = getCount();
    let key      = document.getElementById("key").value.replace(/(.+)#/, "^$1").replace(/(.+)b/, "_$1");
    let meter    = `${count}/${beatType}`;
    let abc      = `X: 1
T: ${title}
C: ${composer}
L: ${defaultL}
K: ${key} treble style=rhythm
Q: 1/4=${tempo}
M: ${meter}
`;
    let previousChord = null;
    for(let i=1; i<=beats.length; i++) {
        let beat    = beats[i-1];
        let chord   = beat['chord'];
        let pattern = beat['pattern'].replaceAll('c', chord[0]);
        if (previousChord !== chord){
            abc += `"${chord}"`;
        }
        previousChord = chord;
        abc += pattern + " ";
        if (i % count === 0 && i !== beats.length) {
            abc += "| ";
        }
        if (i % (measuresPerLine * count) === 0 && i !== beats.length) {
            abc += "\n";
        }
    }

    return abc + "|]";
};

let updateMeasureView = function() {
    measuresPerLine = parseInt(document.getElementById("measuresPerLine").value);
    update();
};

let rand = function(n) {
    return Math.floor(Math.random() * n);
};

let generateMeasure = function() {
    let count            = getCount();
    let measureRemainder = count - (beats.length % count);
    let chord            = getChord();
    for (let i = 0; i < measureRemainder; i++) {
        let pattern = blockPatterns[rand(blockPatterns.length)];
        let useTie  = rand(11) < 2;
        appendHelper(pattern, useTie, chord);
    }
    update();
};

let generate = function() {
    clearScore();
    let chords = ['G', 'G', 'G', 'G', 'D', 'D', 'D', 'D', 'C', 'C', 'C', 'C', 'G', 'G', 'G', 'G'];
    chords.forEach((chord) => {
        let pattern = blockPatterns[rand(blockPatterns.length)];
        let useTie  = rand(11) < 2;
        appendHelper(pattern, useTie, chord);
    });
    document.getElementById('key').selectedIndex = 15; // Key of G
    update();
};

let update = function() {
    let abc = buildAbc();
    document.getElementById("pattern-editor").innerHTML = abc;
    let tune = ABCJS.renderAbc("paper", abc, { responsive: "resize" })[0];

    updateMidi(tune);
};
update();
