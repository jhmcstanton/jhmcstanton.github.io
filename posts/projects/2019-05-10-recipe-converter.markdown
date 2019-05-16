---
title: 'Extract to All-Grain Converter'
---

<script src="/scripts/2019-05-10-recipe-converter.js"></script>
<!-- Style borrowed from StackOverflow https://stackoverflow.com/questions/3790935/can-i-hide-the-html5-number-input-s-spin-box --> 
<style>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

input[type=number] {
    -moz-appearance:textfield; /* Firefox */
}
</style>

Helper scripts, mostly for myself, to convert extract recipes to all grain recipes. Refer to [this _Brew Your Own_ article](https://byo.com/article/extract-to-all-grain-and-back/) for the formula sources.

||||
|-|-|-|
|**Weight** | **Extract** | **Estimated Specific Gravity Contribution** |
| <input type="number" min="0" name="dme-weight" value="" placeholder="0" max="100"> | Dry Malt Extract | 0 |
| <input type="number" min="0" name="lme-weight" value="" placeholder="0"> | Liquid Malt Extract | 0 |
|||
||**Efficiency** | <input id="efficiency" type="number" name="efficiency" value="70" min="0">(%) |

## Dry Malt Extract to Grain

| Grain Type | Percent of Extract | Amount of Grain |
|-|-|-|
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |

## Liquid Malt Extract to Grain

| Grain Type | Percent of Extract | Amount of Grain |
|-|-|-|
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
| <input type="text" placeholder="base"> | <input type="number" min="0" max="100" placeholder="70"> | 0 |
