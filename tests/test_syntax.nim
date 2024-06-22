import cloths

import std/unittest

suite"syntax":
  test"weaving":

    let cloth = weave Margin():
      "abc"

    cloth.weave:
      "def"

    cloth.add "ghi\njkl"

    cloth.add do: weave multiLine:
      "mno"
      "pqr"

    let expect = """abc

def

ghi
jkl

mno
pqr"""
    check $cloth == $cloth
    check $cloth == expect


  test"conditional weaving":
    var idx: int
    let cloth = weave multiline:
      weave text:
        if true:
          "if"
          "true"
        if false:
          "if"
          "false"
      weave text:
        when true:
          "when"
          "true"
        when false:
          "when"
          "false"
      weave text:
        for i, ch in ["a", "b", "c"]:
          "("
          let str = $i & " : " & ch
          str
          ")"
      weave text:
        while idx < 3:
          let i = idx
          $i
          inc idx
      weave text:
        for ch in ["a", "b", "c"]:
          for i in 1..3:
            ch & $i

    let expect = """if true
when true
( 0 : a ) ( 1 : b ) ( 2 : c )
0 1 2
a1 a2 a3 b1 b2 b3 c1 c2 c3"""
    check $cloth == $cloth
    check $cloth == expect
