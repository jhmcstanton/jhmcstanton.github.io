---
title: Chord Progressions
---

A small tool to help easily identify chords in different keys.

<form>
  <p>Select a key type</p>
  <input type="radio" id="major" name="keytype" value="Major" onchange="updateProgression()" checked>
  <label for="major">Major</label>
  <input type="radio" id="minor" name="keytype" value="Natural Minor" onchange="updateProgression()">
  <label for="minor">Minor</label>
  <input type="radio" id="hminor" name="keytype" value="Harmonic Minor" onchange="updateProgression()">
  <label for="hminor">Harmonic Minor</label>
  <input type="radio" id="mminor" name="keytype" value="Melodic Minor" onchange="updateProgression()">
  <label for="mminor">Melodic Minor</label>
  <p>Select a root note</p>
  <select name="rootnote" id="rootnote" onchange="updateProgression()">
    <option value="A">A</option>
    <option value="A#">A#</option>
    <option value="B">B</option>
    <option value="C" selected="selected">C</option>
    <option value="C#">C#</option>
    <option value="D">D</option>
    <option value="D#">D#</option>
    <option value="E">E</option>
    <option value="F">F</option>
    <option value="F#">F#</option>
    <option value="G">G</option>
    <option value="G#">G#</option>
  </select>
</form>

<table>
  <tr>
    <th id="chordnum1">I</th>
    <th id="chordnum2">II</th>
    <th id="chordnum3">III</th>
    <th id="chordnum4">IV</th>
    <th id="chordnum5">V</th>
    <th id="chordnum6">VI</th>
    <th id="chordnum7">VII</th>
  </tr>
  <tr>
    <td id="chord1"></td>
    <td id="chord2"></td>
    <td id="chord3"></td>
    <td id="chord4"></td>
    <td id="chord5"></td>
    <td id="chord6"></td>
    <td id="chord7"></td>
  </tr>
  <tr>
    <td id="notes1"></td>
    <td id="notes2"></td>
    <td id="notes3"></td>
    <td id="notes4"></td>
    <td id="notes5"></td>
    <td id="notes6"></td>
    <td id="notes7"></td>
  </tr>
</table>

If you spot any errors [email me](/contact.html) with the issue and I'll take a look!

<script src="/scripts/2020-09-04-chords.js"/>
