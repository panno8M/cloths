import cloths/sdk
import Prefix

type Indent* {.requiresInit.} = ref object of Style
  level*: Natural
let indent* = Indent(level: 2)

method apply(style: Indent; data: Data): Data =
  apply(Prefix(prefix: sdk.whitespace(style.level)), data)

styletest:
  import cloths/needle
  suite"Indent":
    test"simple":
      let test = weave indent:
        "a"
        "b"
        "c"
      let expect = """
  a
  b
  c"""
      check $test == $test
      check $test == expect
