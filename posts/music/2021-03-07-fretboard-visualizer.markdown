---
title: Fretboard Visualizer
---

A small tool to help visualize where notes are on the fretboard in different
tunings.

<label for="base tuning">Base Tuning to Use</label>
<select name="base tuning" id="tuning" onchange="updateTuningByName(this.value)"></select>
<label for="fret count">Number of Frets</label>
<input name="fret count" type="number" value="24" onchange="updateFrets(this.value)" id="numFrets">
<label for="accidental type">Accidental Type</label>
<select name="accidental type" onchange="updateAccidental(this.value)" id="accidentalType">
  <option selected>Sharp</option>
  <option>Flat</option>
</select>
<label for="string display direction">String Display Direction</label>
<select name="string display direction" onchange="updateDisplayDirection(this.value)" id="high2low">
  <option selected>High to Low</option>
  <option>Low to High</option>
</select>
<br/>
<table>
  <caption>Edit Individual String Tunings</caption>
  <tr id="tuningTable"></tr>
</table>

<div class="board-container">
  <p class="board-left">Nut</p>
  <table class="fretboard" id="fretboard">
    <tr><td>Test</td></tr>
    <tr><td>Test</td></tr>
    <tr><td>Test</td></tr>
    <tr><td>Test</td></tr>
    <tr><td>Test</td></tr>
    <tr><td>Test</td></tr>
  </table>
  <p class="board-right">Bridge</p>
</div>

<link rel="stylesheet" href="/css/fretboard-visualizer.css"/>
<script src="/scripts/2021-03-07-fretboard-visualizer.js"/>
