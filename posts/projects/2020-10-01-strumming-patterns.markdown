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
<label>
  Enable/Disable audio. Audio playback requires additional downloads.
  <input type="checkbox" id="audioEnabled" onClick="update()">
  Number of measures per line.
  <input type="number" id="measuresPerLine" onChange="updateMeasureView()" min="1" value="2">
<label>

<button onClick="clearScore()">Clear Score</button>

## Strumming Blocks

Click a block to add it to your strumming pattern. Each block corresponds to 1 beat in a measure.

<div id="blocks"></div>

Version 1.0
<details>
  <summary><h3>Future Goals</h3>
  <ul>
    <li>Add more patterns</li>
    <li>Generate measures from blocks</li>
    <li>Add tie support</li>
    <li>Support other time signatures</li>
    <li>Add support for direct editing of the ABC markdown</li>
  </ul>
  </summary>
  <h3>Changelog</h3>
  <h4>1.0</h4>
  <p>Initial version, basic 4/4 support</p>
</details>

<link rel="stylesheet" href="/css/2020-10-01-strumming-patterns.css"/>
<link rel="stylesheet" href="/css/abcjs-audio.css"/>
<script src="/scripts/abcjs_basic_5.11.0-min.js"/>
<script src="/scripts/2020-10-01-strumming-patterns.js"/>
