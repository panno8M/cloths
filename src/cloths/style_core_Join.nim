import ./sdk

import std/sequtils
import std/strutils

type Join* = ref object of Style
  delim*: string = ""

method apply(style: Join; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return copy data

  var str: seq[string]

  data.eachAppliedData(meta, subdata):
    str.add subdata.eachline.toSeq.join(style.delim)
  data(str.join(style.delim))

styletest:
  suite"Join":
    test"simple":
      let test = weave Join(delim: " "):
          "abc"
          "def"
          "ghi"
      let expect = "abc def ghi"
      check $test == $test
      check $test == expect

    test"empty":
      let test = cloth Join(delim: " ")
      let expect = ""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave Join(delim: " "):
          "abc"
          weave constant:
            "def"
            "ghi"
      let expect = "abc def ghi"
      check $test == $test
      check $test == expect

    test"inner-empty":
      let test = weave Join(delim: " "):
          "abc"
          cloth empty
          "def"
          "ghi"
      let expect = "abc def ghi"
      check $test == $test
      check $test == expect