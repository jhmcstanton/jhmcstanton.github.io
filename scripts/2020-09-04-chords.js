const convertNote = {
    "Ab": "G#", "A": "A", "A#": "Bb", "B": "B", "C": "C", "C#": "Db",
    "D": "D", "D#": "Eb", "E": "E", "F": "F", "F#": "Gb", "G": "G"
};
const unison = 0;
const m2     = 1;
const M2     = 2;
const m3     = 3;
const M3     = 4;
const intervals = {
    "Major":          [unison, M2, M2, m2, M2, M2, M2],
    "Natural Minor":  [unison, M2, m2, M2, M2, m2, M2],
    "Harmonic Minor": [unison, M2, m2, M2, M2, m2, m3],
    "Melodic Minor":  [unison, M2, m2, M2, M2, M2, M2]
};
const chordNumbers = [
    "I", "II", "III", "IV", "V", "VI", "VII"
];
const notes = [
    "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"
];
notes = notes.concat(notes);
const flatNotes = [
    "Ab", "A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G"
];
flatNotes      = flatNotes.concat(flatNotes);
const flatKeys = ['F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb', 'Cb'];
const major      = "Major";
const minor      = "Minor";
const diminished = "Diminished";
const augmented  = "Augmented";

const chordNumber = function(num, chordType) {
    switch (chordType) {
    case minor:      return num.toLowerCase();
    case major:      return num.toUpperCase();
    case diminished: return num.toLowerCase() + "&deg;";
    case augmented:  return num.toUpperCase() + "+";
    }
    console.log("unknown chord type " + chordType + " corresponding number: " + num);
    return "Should not happen";
};

const dropWhile = function(f, arr) {
    let i = 0;
    while (i < arr.length && f(arr[i])) {
        i++;
    }
    return arr.slice(i);
};

const buildKey = function(note, keyType) {
    const potentialNotes = dropWhile((n) => n !== note, flatKeys.includes(note) ? flatNotes : notes);
    const keyIntervals = intervals[keyType];
    const keyNotes = [];
    let i = 0;
    keyIntervals.forEach((interval) => {
        i += interval;
        keyNotes.push(potentialNotes[i]);
    });
    return keyNotes.concat(keyNotes);
};

const isChordHelper = function(expectedIntervals) {
    return (chord, key) => {
        const notesFromRoot = dropWhile((note) => note !== chord[0], flatKeys.includes(key) ? flatNotes : notes);
        return notesFromRoot.indexOf(chord[1]) - notesFromRoot.indexOf(chord[0]) == expectedIntervals[0] &&
            notesFromRoot.indexOf(chord[2]) - notesFromRoot.indexOf(chord[1]) == expectedIntervals[1];
    };
};
const isMajorChord = isChordHelper([M3, m3]);
const isMinorChord = isChordHelper([m3, M3]);
const isDimChord   = isChordHelper([m3, m3]);
const isAugChord   = isChordHelper([M3, M3]);
const chordType    = function(chord, key) {
    if (isMajorChord(chord, key)) {
        return major;
    } else if (isMinorChord(chord, key)) {
        return minor;
    } else if (isDimChord(chord, key)) {
        return diminished;
    } else if (isAugChord(chord, key)) {
        return augmented;
    } else {
        console.log("Unknown chord type for chord: " + chord);
        return "Should not happen, chord: " + chord;
    }
};
const chordName     = function(chord, chordType) {
    switch(chordType) {
    case major:      return chord[0];
    case minor:      return chord[0] + "min";
    case diminished: return chord[0] + "&deg;";
    case augmented:  return chord[0] + "+";
    }
    console.log("Unknown chord name for chord: " + chord + " , type: " + chordType);
    return "Should not happen, chord: " + chord;
};

const buildChord = function(root, key) {
    const rootIndex = key.indexOf(root);
    const chord     = [key[rootIndex], key[rootIndex + 2], key[rootIndex + 4]];
    const cType     = chordType(chord, key[0]);
    const cName     = chordName(chord, cType);
    const chordNum  = chordNumbers[rootIndex];
    return { "name" : cName, "chord" : chord, "number": chordNumber(chordNum, cType)};
};

const updateProgression = function() {
    let rootNote   = document.getElementById("rootnote").value;
    let keyType    = "unknown";
    let typeRadios = document.getElementsByName("keytype");
    for (let i = 0; i < typeRadios.length; i++) {
        if (typeRadios[i].checked) {
            keyType = typeRadios[i].value;
            break;
        }
    }
    if (keyType === "unknown") {
        alert("Something went wrong while determining the key");
        return;
    }
    let key = buildKey(rootNote, keyType);
    for(let i = 0; i < 7; i++) {
        let headerId     = "chordnum" + (i + 1);
        let dataId       = "chord"    + (i + 1);
        let notesId      = "notes"    + (i + 1);
        let chordDetails = buildChord(key[i], key);
        document.getElementById(headerId).innerHTML = chordDetails["number"];
        document.getElementById(dataId)  .innerHTML = chordDetails["name"];
        document.getElementById(notesId) .innerHTML = chordDetails["chord"];
    }
};

updateProgression();
