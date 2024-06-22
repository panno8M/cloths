import cloths/sdk
import Prefix

type Indent* = ref object of Style
  super: Prefix
proc indent*(level: Natural): Indent = Indent(super: Prefix(prefix: sdk.whitespace(level)))
let indent2* = indent(2)

method apply(style: Indent; data: Data): Data = apply(style.super, data)

styletest:
  import cloths/needle
  suite"Indent":
    test"simple":
      let test = weave indent2:
        "a"
        "b"
        "c"
      let expect = """  a
  b
  c"""
      check $test == $test
      check $test == expect
