const abc   = document.getElementById('score');
const paper = document.getElementById('paper');
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
    chordsOff: true
};

const s = abc.value;
const pageTitle = document.getElementsByTagName('h1')[0].innerHTML;
abc.value = `X: 1
C: Jim McStanton
${s.includes('T:') ? '' : `T: ${pageTitle}`}
${abc.innerHTML}
`;

// const audioRequest = document.createElement('template');
// audioRequest.innerHTML=`<label for="Enable Audio">Enable/Disable audio. Audio playback requires additional downloads.</label>
// <input type="checkbox" id="audioEnabled" onClick="render()">
// `;
// paper.parentNode.insertBefore(audioDetails.content, paper.nextSibling);

const eventCallback = function(ev) {
    document.querySelectorAll('.cursor-note').forEach((el) => el.classList.remove('cursor-note'));
    const elements = ev['elements'].forEach((el) => el[0].classList.add('cursor-note'));
};

const updateMidi = function(tune) {
    // if (!document.getElementById("audioEnabled").checked) {
    //     document.getElementById("audio").innerHTML = "";
    //     return;
    // }
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

function render() {
    const s = abc.value.replaceAll("\n\n", "\n");
    const p = ABCJS.renderAbc('paper', s)[0];
    updateMidi(p);
};

render();
