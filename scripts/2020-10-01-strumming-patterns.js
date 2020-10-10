const count            = 4;
const beatType         = 4;
const tempo            = "60";
const defaultL         = "1/16";
const measuresPerLine  = 2;
const down             = "↓";
const up               = "↑";
const strumPlaceholder = "S";
const beats          = [
    {pattern:`"↓"c2"""S"c2`      , chord: "C"},
    {pattern: `"↓"c3"""↑"c`      , chord: "C"},
    {pattern: `"↓"c"""↑"c"""↓"c2`, chord: "D"},
    {pattern: `"↓"c2"""S"c2`     , chord: "D"}
];
// Audio control options
const audioEnabled   = false;
const displayOptions = {
    displayLoop     : true,
    displayRestart  : true,
    displayPlay     : true,
    displayProgress : true,
    displayWarp     : true
};
const audioOptions   = {
    chordsOff: false
};

const blockPatterns = [`"↓"c4`, `"↓"c2"""S"c2`, `"↓"c"""↑"c"""↓"c"""↑"c`, `"↓"c2"""↓"c"""↑"c`, `"↓"c"""↑"c"""↓"c2`, `"↓"c3"""↑"c`, `"↓"c"""↑"c3`];

const blocksSection   = document.getElementById("blocks");
for (const i=0; i < blockPatterns.length; i++) {
    const pattern = blockPatterns[i].replaceAll('""', '');
    const abc = `X:${i+2}
L: ${defaultL}
K: C treble style=rhythm
${pattern}`;
    const blockId   = `block-${i}`;
    const blockHtml = `<div class="block">
<div id="${blockId}" onclick="append(${i})()" ></div>
<label>Leading tie <input type="checkbox" id="${blockId}-tie"></label>
</div>`;
    blocksSection.innerHTML += blockHtml;
    ABCJS.renderAbc(blockId, abc);
}

const usesSixteenths = function() {
    return beats.some((b) => b['pattern'].includes('"c"'));
};

const updateEighths = function() {
    const blockId       = `block-1`;
    const eighthOffbeat = usesSixteenths() ? down : up;
    const pattern       = blockPatterns[1].replace(strumPlaceholder, eighthOffbeat).replace('""', '');
    const el            = document.getElementById(blockId);
    const abc = `X:3
L: ${defaultL}
K: C treble style=rhythm
${pattern}`;
    ABCJS.renderAbc(blockId, abc);
};

const eventCallback = function(ev) {
    document.querySelectorAll('.cursor-note').forEach((el) => el.classList.remove('cursor-note'));
    const elements = ev['elements'].forEach((el) => el[0].classList.add('cursor-note'));
};

const updateMidi = function(tune) {
    if (!document.getElementById("audioEnabled").checked) {
        document.getElementById("audio").innerHTML = "";
        return;
    }
    if (ABCJS.synth.supportsAudio()) {
        const synthControl = new ABCJS.synth.SynthController();
        synthControl.load("#audio", { onEvent: eventCallback }, displayOptions);
    } else {
        document.getElementById("audio").innerHTML = "Audio not supported in this browser";
        return;
    }
    const synth = new ABCJS.synth.CreateSynth();
    synth.init({ visualObj: tune }).then(() => {
        synthControl.setTune(tune, false, audioOptions)
            .then(() => console.log("Audio loaded"))
            .catch((error) => console.warn("Audio problem: ", error));
    }).catch((error) => console.warn("Audio problem during init: ", error));
};

const clearScore = function() {
    beats.length = 0;
    update();
};

const removeLastBeat = function() {
    beats.pop();
    update();
};

const appendHelper = function(pattern, useTie, chord) {
    if (useTie) {
        pattern = "-" + pattern;
    }
    const beat = {pattern: pattern, chord: chord };
    beats.push(beat);
    update();
};

const append = function(i) {
    return function() {
        const pattern = blockPatterns[i];
        const useTie  = document.getElementById(`block-${i}-tie`).checked;
        const chord   = getChord();
        appendHelper(pattern, useTie, chord);
    };
};

const getCount = function() {
    return parseInt(document.getElementById("beatsPerMeasure").value);
};

const getChord = function() {
    return document.getElementById('nextChord').value;
};

const buildAbc = function() {
    const title    = document.getElementById("title").value;
    const composer = document.getElementById("composer").value;
    const count    = getCount();
    const key      = document.getElementById("key").value.replace(/(.+)#/, "^$1").replace(/(.+)b/, "_$1");
    const meter    = `${count}/${beatType}`;
    let abc        = `X: 1
T: ${title}
C: ${composer}
L: ${defaultL}
K: ${key} treble style=rhythm
Q: 1/4=${tempo}
M: ${meter}
`;
    let previousChord   = null;
    const eighthOffbeat = usesSixteenths() ? down : up;
    for(let i=1; i<=beats.length; i++) {
        const beat    = beats[i-1];
        const chord   = beat['chord'];
        const pattern = beat['pattern'].replaceAll('c', chord[0]);
        console.log(`pchord: ${previousChord}| chord: ${chord}`);
        if (previousChord === chord) {
            console.log('adding space');
            abc += '""';
        } else {
            abc += `"${chord}"`;
        }
        previousChord = chord;
        abc += pattern.replace(strumPlaceholder, eighthOffbeat) + " ";
        if (i % count === 0 && i !== beats.length) {
            abc += "| ";
        }
        if (i % (measuresPerLine * count) === 0 && i !== beats.length) {
            abc += "\n";
        }
    }

    return abc + "|]";
};

const updateMeasureView = function() {
    measuresPerLine = parseInt(document.getElementById("measuresPerLine").value);
    update();
};

const checkCopyMeasure = function(measure) {
    measure = parseInt(measure);
    const el = document.getElementById("copyMeasure");
    const totalMeasures = Math.floor(beats.length / count);
    if (measure < 1) {
        measure = 1;
    } else if(measure > totalMeasures) {
        measure = totalMeasures;
    }
    el.value = measure;
    return measure - 1;
};

const copyMeasure = function() {
    const copyMeasure = checkCopyMeasure(document.getElementById("copyMeasure").value);
    const start       = copyMeasure * count;
    const end         = beats.length < start + count ? beats.length : start + count;
    for (let i = start + beats.length % count; i < end; i++) {
        beats.push(beats[i]);
    }
    update();
};

const rand = function(n) {
    return Math.floor(Math.random() * n);
};

const generateMeasure = function() {
    const count            = getCount();
    const measureRemainder = count - (beats.length % count);
    const chord            = getChord();
    for (let i = 0; i < measureRemainder; i++) {
        const pattern = blockPatterns[rand(blockPatterns.length)];
        const useTie  = rand(11) < 2;
        appendHelper(pattern, useTie, chord);
    }
    update();
};

const generate = function() {
    clearScore();
    const chords = ['G', 'G', 'G', 'G', 'D', 'D', 'D', 'D', 'C', 'C', 'C', 'C', 'G', 'G', 'G', 'G'];
    chords.forEach((chord) => {
        const pattern = blockPatterns[rand(blockPatterns.length)];
        const useTie  = rand(11) < 2;
        appendHelper(pattern, useTie, chord);
    });
    document.getElementById('key').selectedIndex = 15; // Key of G
    update();
};

const update = function() {
    const abc = buildAbc();
    document.getElementById("pattern-editor").innerHTML = abc;
    const tune = ABCJS.renderAbc("paper", abc, { responsive: "resize" })[0];
    updateEighths();
    updateMidi(tune);
};
update();
