import cloths
import cloths/style_markdown

import std/unittest

suite"nil(Cloth) As Empty":
  test"stringify":
    var test: Cloth
    check $test == $test
    check $test == ""
  test"nil node":
    let test = weave orderedList:
      "aaa"
      "bbb"
      Cloth()
      "ccc"
    let expect = """1. aaa
2. bbb
3. ccc"""
    check $test == $test
    check $test == expect