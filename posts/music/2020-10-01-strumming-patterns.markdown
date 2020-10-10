---
title: Strumming Patterns
---

A tool to build strumming patterns. This is just for building out some rhythm to play with, not for
properly composing music.


<details>
  <summary>This tool uses <a href="https://paulrosen.github.io/abcjs/"><code>abcjs</code></a> for score editing. You can view
  the <code>abcjs</code> markdown directly here.</summary>
  <textarea name="pattern-editor" id="pattern-editor" rows=10 readonly></textarea>
</details>


<div id="paper"></div>
<div id="audio"></div>
<form>
  <label for="Title">Title:</label>
  <input type="text" value="Your Cool Strumming Pattern" id="title" oninput="update()">
  <label for="Composer">Composer:</label>
  <input type="text" value="You" id="composer" oninput="update()">
  <label for="Enable Audio">Enable/Disable audio. Audio playback requires additional downloads.</label>
  <input type="checkbox" id="audioEnabled" onClick="update()">
  <label for="Measures per line">Number of measures per line</label>
  <input type="number" id="measuresPerLine" onChange="updateMeasureView()" min="1" value="2">
  <label for="Beats per measure">Number of beats per measure</label>
  <input type="number" id="beatsPerMeasure" oninput="updateMeasureView()" min="1" value="4">
  <label for="key">Key of Score</label>
  <select name="key" id="key" onchange="update()">
    <option value="Ab">A♭</option>
    <option value="A">A</option>
    <option value="A#">A♯</option>
    <option value="Bb">B♭</option>
    <option value="B">B</option>
    <option value="C" selected="selected">C</option>
    <option value="C#">C♯</option>
    <option value="Db">D♭</option>
    <option value="D">D</option>
    <option value="D#">D♯</option>
    <option value="Eb">E♭</option>
    <option value="E">E</option>
    <option value="F">F</option>
    <option value="F#">F♯</option>
    <option value="Gb">G♭</option>
    <option value="G">G</option>
    <option value="G#">G♯</option>
  </select>
  <label for="next chord">Next Chord:</label>
  <input type="text" id="nextChord" value="C">
  <label for="measure to copy">Measure to Copy:</label>
  <input type="number" id="copyMeasure" value="1" min="1" onChange="checkCopyMeasure(this.value)">
</form>

<button onClick="copyMeasure()">Copy Measure</button>
<button onClick="removeLastBeat()">Remove Last Beat</button>
<button onClick="clearScore()">Clear Score</button>
<button onClick="generateMeasure()">Generate New Measure</button>
<button onClick="generate()">Generate New Score</button>

## Strumming Blocks

Click a block to add it to your strumming pattern. Each block corresponds to 1 beat in a measure.

<div id="blocks"></div>

Version 1.7
<details>
  <summary><h3>Future Goals</h3>
  <ul>
    <li>Add more patterns</li>
    <li>Add more generation support</li>
    <li>Support other time signatures</li>
    <li>Add support for direct editing of the ABC markdown</li>
  </ul>
  </summary>
  <h3>Changelog</h3>
  <h4>1.7</h4>
  Added strumming arrows to beats.
  <h4>1.6</h4>
  Added support for appending copies of previous measures to the score.
  <h4>1.5</h4>
  Added support for generating new scores and new measures.
  <h4>1.4</h4>
  Added chord support.
  Added title and composer editing.
  Added remove last beat button.
  <h4>1.3</h4>
  Added support for changing number of beats per measure.
  <h4>1.2</h4>
  Added basic tie support.
  <h4>1.1</h4>
  Added note highlighting while playing audio.
  <h4>1.0</h4>
  <p>Initial version, basic 4/4 support.</p>
</details>

<link rel="stylesheet" href="/css/2020-10-01-strumming-patterns.css"/>
<link rel="stylesheet" href="/css/abcjs-audio.css"/>
<script src="/scripts/abcjs_basic_5.11.0-min.js"/>
<script src="/scripts/2020-10-01-strumming-patterns.js"/>
