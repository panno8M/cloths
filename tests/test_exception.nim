import std/unittest

import cloths
import cloths/styles/exception

suite"error handring":
  test"raised":
    let test = weave transact:
      "cloths"
      weave Proof(elements: 1):
        weave empty:
          "aaa"
          "bbb"
          "ccc"
    let expect = ""
    check $test == $test
    check $test == expect
  test"unraised":
    let test = weave transact:
      "cloths"
      weave Proof(elements: 1):
        weave multiline:
          "aaa"
          "bbb"
          "ccc"
    let expect = """cloths
aaa
bbb
ccc"""
    check $test == $test
    check $test == expect