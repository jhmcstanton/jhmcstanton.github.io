let convertNote = {
    "Ab": "G#", "A": "A", "A#": "Bb", "B": "B", "C": "C", "C#": "Db",
    "D": "D", "D#": "Eb", "E": "E", "F": "F", "F#": "Gb", "G": "G"
};
let unison = 0;
let m2     = 1;
let M2     = 2;
let m3     = 3;
let M3     = 4;
let intervals = {
    "Major":          [unison, M2, M2, m2, M2, M2, M2],
    "Natural Minor":  [unison, M2, m2, M2, M2, m2, M2],
    "Harmonic Minor": [unison, M2, m2, M2, M2, m2, m3],
    "Melodic Minor":  [unison, M2, m2, M2, M2, M2, M2]
};
let chordNumbers = [
    "I", "II", "III", "IV", "V", "VI", "VII"
];
let notes = [
    "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"
];
notes = notes.concat(notes);
let flatNotes = [
    "Ab", "A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G"
];
flatNotes      = flatNotes.concat(flatNotes);
let major      = "Major";
let minor      = "Minor";
let diminished = "Diminished";
let augmented  = "Augmented";

let chordNumber = function(num, chordType) {
    switch (chordType) {
    case minor:      return num.toLowerCase();
    case major:      return num.toUpperCase();
    case diminished: return num.toLowerCase() + "&deg;";
    case augmented:  return num.toUpperCase() + "+";
    }
    console.log("unknown chord type " + chordType + " corresponding number: " + num);
    return "Should not happen";
};

let dropWhile = function(f, arr) {
    let i = 0;
    while (i < arr.length && f(arr[i])) {
        i++;
    }
    return arr.slice(i);
};

let buildKey = function(note, keyType) {
    let potentialNotes = dropWhile((n) => n !== note, notes);
    let keyIntervals = intervals[keyType];
    let keyNotes = [];
    let i = 0;
    keyIntervals.forEach((interval) => {
        i += interval;
        keyNotes.push(potentialNotes[i]);
    });
    return keyNotes.concat(keyNotes);
};

let isChordHelper = function(expectedIntervals) {
    return (chord) => {
        let notesFromRoot = dropWhile((note) => note !== chord[0], notes);
        return notesFromRoot.indexOf(chord[1]) - notesFromRoot.indexOf(chord[0]) == expectedIntervals[0] &&
            notesFromRoot.indexOf(chord[2]) - notesFromRoot.indexOf(chord[1]) == expectedIntervals[1];
    };
};
let isMajorChord = isChordHelper([M3, m3]);
let isMinorChord = isChordHelper([m3, M3]);
let isDimChord   = isChordHelper([m3, m3]);
let isAugChord   = isChordHelper([M3, M3]);
let chordType    = function(chord) {
    if (isMajorChord(chord)) {
        return major;
    } else if (isMinorChord(chord)) {
        return minor;
    } else if (isDimChord(chord)) {
        return diminished;
    } else if (isAugChord(chord)) {
        return augmented;
    } else {
        console.log("Unknown chord type for chord: " + chord);
        return "Should not happen, chord: " + chord;
    }
};
let chordName     = function(chord, chordType) {
    switch(chordType) {
    case major:      return chord[0];
    case minor:      return chord[0] + "min";
    case diminished: return chord[0] + "&deg;";
    case augmented:  return chord[0] + "+";
    }
    console.log("Unknown chord name for chord: " + chord + " , type: " + chordType);
    return "Should not happen, chord: " + chord;
};

let buildChord = function(root, key) {
    let rootIndex = key.indexOf(root);
    let chord     = [key[rootIndex], key[rootIndex + 2], key[rootIndex + 4]];
    let cType     = chordType(chord);
    let cName     = chordName(chord, cType);
    let chordNum  = chordNumbers[rootIndex];
    return { "name" : cName, "chord" : chord, "number": chordNumber(chordNum, cType)};
};

let updateProgression = function() {
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
