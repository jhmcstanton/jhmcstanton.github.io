let count           = 4;
let beatType        = 4;
let tempo           = "60";
let n               = "c";
let defaultL        = "1/16";
let measuresPerLine = 2;
let beats          = ["c2c2", "c3c", "ccc2", "c2cw"];
// Audio control options
let audioEnabled   = false;
let displayOptions = {
    displayLoop     : true,
    displayRestart  : true,
    displayPlay     : true,
    displayProgress : true,
    displayWarp     : true
};
let audioOptions   = {
    chordsOff: true
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

let append = function(i) {
    return function() {
        let pattern = blockPatterns[i];
        if (document.getElementById(`block-${i}-tie`).checked) {
            pattern = "-" + pattern;
        }
        beats.push(pattern);
        update();
    };
};

let buildAbc = function() {
    let count = parseInt(document.getElementById("beatsPerMeasure").value);
    let meter = `${count}/${beatType}`;
    let abc   = `X: 1
T: Your Cool Strumming Pattern
C: You
L: ${defaultL}
K: C treble style=rhythm
Q: 1/4=${tempo}
M: ${meter}
`;
    for(let i=1; i<=beats.length; i++) {
        let beat = beats[i-1];
        abc += beat + " ";
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

let update = function() {
    let abc = buildAbc();
    document.getElementById("pattern-editor").innerHTML = abc;
    let tune = ABCJS.renderAbc("paper", abc, { responsive: "resize" })[0];

    updateMidi(tune);
};
update();
