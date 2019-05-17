---
title: 'Extract to All-Grain Converter'
---

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
|**Extract** | **Weight** | **Estimated Specific Gravity Contribution** |
| Dry Malt Extract | <input type="number" min="0" name="dme-weight" value="" placeholder="0" max="100"> | 0 |
|Liquid Malt Extract | <input type="number" min="0" name="lme-weight" value="" placeholder="0"> | 0 |
|||
| Batch Size | <input id="batchSize" type="number" name="batchSize" value="1" min="0" placeholder="1">(gal) | |
| Efficiency | <input id="efficiency" type="number" name="efficiency" value="70" min="0">(%) | |

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

<script src="/scripts/2019-05-10-recipe-converter.js"></script>
