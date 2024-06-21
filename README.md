# Cloths

## Overview
```nim
import cloths
import cloths/styles/markdown
echo:
  weave multiline:
    "Cloths"
    "provides"
    weave text:
      "the"
      "way"
      "to"
    weave Tree():
      weave orderedList:
        "process"
        "and"
        "structure"
      weave multiline:
        "string"
        weave Tree() >> Underline(pattern: "~"):
          "easily."
#[ ==> output:
Cloths
provides
the way to
├─ 1. process
│  2. and
│  3. structure
└─ string
   └─ easily.
      ~~~~~~~
]#
```

## User Manual

see [documentation](https://panno8m.github.io/cloths/cloths).

## Dependencies

### Required

* Nim Compiler >= 2.0.0

### Recommended

* Nimble

## Instalation

```sh
nimble install cloths
```

```sh
git clone https://github.com/panno8M/cloths.git
cd cloths
nimble install
```