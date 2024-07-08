import cloths/sdk
import std/sequtils

type Margin* {.requiresInit.} = ref object of Style
  thickness*: Natural

let margin* = Margin(thickness: 1)

proc makeMargin(thickness: Natural): Cloth =
  cloth data cloth"".repeat(thickness)

method apply(style: Margin; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return data
  new  result
  let margin = makeMargin(style.thickness)

  data.eachAppliedData(meta, subdata):
    result.subitems.add cloth subdata
    if not meta.isLastItem:
      result.subitems.add margin

styletest:
  import cloths/needle
  import Empty
  suite"Margin":
    test"single":
      let test = weave margin:
        "abc"
      let expect = "abc"
      check $test == $test
      check $test == expect

    test"empty":
      let test = cloth margin
      let expect = ""
      check $test == $test
      check $test == expect

    test"multiline":
      let test = weave margin:
        "abc"
        "def"
        "ghi"
      let expect = """
abc

def

ghi"""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave margin:
        "abc"
        weave constant:
          "def"
          "ghi"
        "jkl"
      let expect = """
abc

def
ghi

jkl"""
      check $test == $test
      check $test == expect

    test"inner-empty":
      let test = weave margin:
        "abc"
        cloth empty
        "def"
      let expect = """
abc

def"""
      check $test == $test
      check $test == expect

    test"thickness":
      let test = weave Margin(thickness: 2):
        "abc"
        "def"
        "ghi"
      let expect = """
abc


def


ghi"""
      check $test == $test
      check $test == expect