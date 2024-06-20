import cloths
import cloths/style_markdown

import std/unittest

suite"nil(Cloth) As Empty":
  test"stringify":
    let test: Cloth = nil
    check $test == $test
    check $test == ""
  test"nil node":
    let test = weave orderedList:
      "aaa"
      "bbb"
      nil
      "ccc"
    let expect = """1. aaa
2. bbb
3. ccc"""
    check $test == $test
    check $test == expect