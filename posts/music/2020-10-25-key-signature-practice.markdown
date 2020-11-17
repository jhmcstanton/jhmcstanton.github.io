---
title: Key Signature Practice
---


<h2>Identify the Key Signature</h2>
<p id="result"></p>
<div id="paper"></div>
<p>Use 'b' for flat and '#' for sharp.</p>
<details>
<summary>
Check this drop down for additional tips.
</summary>
  <ul>
    <li>The order of sharps are: F, C, G, D, A, E, B.</li>
    <li>The order of flats are: B, E, A, D, G, C, F.</li> 
    <li>The last note of the major scale is the last sharp of the signature</li>
    <li>In a flat (major) key signature the tonic is always in the same position of the signature, <i>except</i> for the
    first flat key signature.</li>
  </ul>
</details>

<input type="text" placeholder="C" id="answer">
<button onclick="quiz()">Submit</button>
<select name="keytype" id="keytype">
  <option value="maj" selected="selected">Major</option>
  <option value="min">Minor</option>
</select>
<select name="clef" id="clef">
  <option value="treble">Treble</option>
  <option value="bass">Bass</option>
  <option value="alto">Alto</option>
  <option value="tenor">Tenor</option>
</select>
<script src="/scripts/abcjs_basic_5.11.0-min.js"/>
<script src="/scripts/2020-10-25-key-signature-practice.js"/>
