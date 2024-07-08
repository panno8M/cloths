import cloths

import std/unittest

suite"syntax":
  test"weaving":

    let cloth = weave margin:
      "abc"

    cloth.weave:
      "def"

    cloth.add "ghi\njkl"

    cloth.add do: weave multiLine:
      "mno"
      "pqr"

    let expect = """
abc

def

ghi
jkl

mno
pqr"""
    check $cloth == $cloth
    check $cloth == expect


  test"conditional weaving":
    let cloth = weave multiline:
      weave text:
        if true:
          "if"
          "true"
        if false:
          "if"
          "false"
        else:
          "if"
          "not false"
      weave text:
        when true:
          "when"
          "true"
        when false:
          "when"
          "false"
        else:
          "when"
          "not false"
      weave text:
        for i, ch in ["a", "b", "c"]:
          "("
          let str = $i & " : " & ch
          str
          ")"
      weave text:
        var idx: int
        while idx < 3:
          let i = idx
          $i
          inc idx
      weave text:
        for ch in ["a", "b", "c"]:
          for i in 1..3:
            ch & $i
      weave text:
        for str in ["ofStmt", "elifStmt", "elseStmt"]:
          case str
          of "ofStmt":
            "case"
            "of stmt"
          elif str == "elifStmt":
            "case"
            "elif stmt"
          else:
            "case"
            "else stmt"

    let expect = """
if true if not false
when true when not false
( 0 : a ) ( 1 : b ) ( 2 : c )
0 1 2
a1 a2 a3 b1 b2 b3 c1 c2 c3
case of stmt case elif stmt case else stmt"""
    check $cloth == $cloth
    check $cloth == expect