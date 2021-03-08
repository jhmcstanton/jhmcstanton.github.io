const sharps = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
const flats  = ['A', 'B♭', 'B', 'C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭'];
const getNoteMaker = function(arr) {
    return function(i) {
        return arr[Math.abs(i) % 12];
    };
};
const getSharpNote = getNoteMaker(sharps);
const getFlatNote  = getNoteMaker(flats);
const noteMaps = { 'sharp': getSharpNote, 'flat' : getFlatNote };

const makeStandardTuning = function(note) {
    note = note.toUpperCase();
    const notes = [note];
    for(let i = sharps.indexOf(note) + 5; notes.length < 6; i+=5) {
        if (notes.length == 4) {
            i--;
        }
        notes.push(getSharpNote(i));
    }
    return notes;
};
const makeDropTuning = function(note) {
    const notes = makeStandardTuning(getSharpNote(sharps.indexOf(note) + 2 % 12));
    notes[0] = getSharpNote(sharps.indexOf(notes[0]) - 2 % 12);
    return notes;
};
const makeFlatTuning = function(notes) {
    const newNotes = [];
    notes.forEach(note => {
        newNotes.push(flats[sharps.indexOf(note)]);
    });
    return newNotes;
};
const tunings  = {
    'E Standard'  : makeStandardTuning('E'),
    'Drop D'      : makeDropTuning('D'),
    'Open A'      : ['E', 'A','C#', 'E', 'A', 'E'],
    'Open B'      : ['B', 'F#', 'B', 'F#', 'B', 'D#'],
    'Open C'      : ['C', 'G', 'C', 'G', 'C', 'E'],
    'Open D'      : ['D', 'A', 'D', 'F#', 'A', 'D'],
    'Open E'      : ['E', 'B', 'E', 'G#', 'B', 'E'],
    'Open F'      : ['C', 'F', 'C', 'F', 'A', 'C'],
    'Open G'      : ['D', 'G', 'D', 'G', 'B', 'D'],
    'E♭ Standard' : makeFlatTuning(makeStandardTuning('D#')),
    'Drop D♭'     : makeFlatTuning(makeDropTuning('C#')),
    'D Standard'  : makeStandardTuning('D'),
    'Drop C'      : makeDropTuning('C'),
    'C# Standard' : makeStandardTuning('C#'),
    'Drop B'      : makeDropTuning('B'),
    'C Standard'  : makeStandardTuning('C'),
    'Drop B♭'     : makeFlatTuning(makeDropTuning('A#')),
    'B Standard'  : makeStandardTuning('B'),
    'Drop A'      : makeDropTuning('A'),
    'A# Standard' : makeStandardTuning('A#'),
    'Drop G#'     : makeDropTuning('G#'),
    'A Standard'  : makeStandardTuning('A'),
    'Drop G'      : makeDropTuning('G')
};

let tuning     = document.getElementById('tuning').value;
let numStrings = 6;
let numFrets   = parseInt(document.getElementById('numFrets').value);
let useSharps  = document.getElementById('accidentalType').value === 'Sharp';
let high2low   = document.getElementById('high2low').value === 'High to Low';


const updateTuningByName = function(newTuning) {
    tuning          = tunings[newTuning];
    const notes     = useSharps ? sharps : flats;
    const selectors = document.getElementsByClassName('stringNoteSelector');
    for(let i = 0; i < selectors.length; i++) {
        let note = tuning[i];
        let stringSelect = selectors[i];
        stringSelect.selectedIndex = notes.indexOf(note);
    }
    buildFretboard(tuning);
};

const buildFretboard = function(stringNotes) {
    const board = document.getElementById('fretboard');
    board.innerHTML = "";
    const allNotes = useSharps ? noteMaps['sharp'] : noteMaps['flat'];
    stringNotes.forEach(note => {
        const string = board.insertRow(high2low ? 0 : -1);
        let startIndex = sharps.indexOf(note);
        startIndex     = startIndex >= 0 ? startIndex : flats.indexOf(note);
        for(let i = startIndex; i < startIndex + numFrets; i++) {
            const fret = string.insertCell(-1);
            fret.innerHTML = allNotes(i);
        }
    });
    const header = board.insertRow(0);
    for(let i = 1; i <= numFrets; i++) {
        const cell = header.insertCell(-1);
        if(i % 2 === 1 && [1, 11, 13].indexOf(i) === -1) {
            cell.innerHTML = "⬤";
        } else if(i === 12) {
            cell.innerHTML = "⬤ ⬤";
        }
    }
};

const updateFrets = function(num) {
    numFrets = parseInt(num);
    buildFretboard(tuning);
};

const updateAccidental = function(accType) {
    useSharps = accType === 'Sharp';
    buildFretboard(tuning);
};

const updateDisplayDirection = function(dir) {
    high2low = dir === 'High to Low';
    buildFretboard(tuning);
};

const updateString = function(strEl, strIndex) {
    tuning[strIndex] = strEl.value;
    buildFretboard(tuning);
};

// Populate the tuning drop down
const tuningEl = document.getElementById('tuning');
for (const key in tunings) {
    const tuningOption = document.createElement('option');
    tuningOption.text = key;
    tuningEl.add(tuningOption);
}

updateTuningByName('E Standard');

// Populate tuning table drop downs
const tuningRow = document.getElementById('tuningTable');
for (let i = 0; i < numStrings; i++) {
    let currentNote = tuning[i];
    let notes = useSharps ? sharps : flats;
    let string = tuningRow.insertCell(-1);
    let stringSelect = document.createElement('select');
    stringSelect.className = 'stringNoteSelector';
    stringSelect.onchange = () => updateString(stringSelect, i);
    string.appendChild(stringSelect);
    notes.forEach(note => {
        const noteOpt = document.createElement('option');
        noteOpt.text = note;
        stringSelect.add(noteOpt);
    });
    stringSelect.selectedIndex = notes.indexOf(currentNote);
}
