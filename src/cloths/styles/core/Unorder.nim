import cloths/sdk

type Unorder* = ref object of Style
  entry*: string = "* "

method apply(style: Unorder; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return data(style.entry & data.str)
  new result
  let indent = sdk.whitespace(style.entry.len)

  data.eachAppliedData(meta, subdata):

    for i_line, line in subdata.eachpair:
      line =
        if i_line == 0: style.entry & line
        else:           indent & line

    result.subitems.add cloth subdata

styletest:
  import cloths/needle
  import Empty
  suite"Unorder":
    test"simple":
      let test = weave Unorder(entry: "* "):
          "abc"
          "def"
          "ghi"
      let expect = """* abc
* def
* ghi"""
      check $test == $test
      check $test == expect

    test "empty":
      let test = cloth Unorder()
      let expect = ""
      check $test == $test
      check $test == expect

    test "inner-empty":
      let test = weave Unorder():
        cloth empty
        "a"
        cloth empty
        "b"
        cloth empty
        "c"
        cloth empty

      let expect = """* a
* b
* c"""
      check $test == $test
      check $test == expect

    test "complex":
      let test = weave Unorder():
        "a"
        weave Unorder(entry: "- "):
          "b"
          cloth empty
          weave Unorder():
            "c"
            "d"
          weave Unorder():
            "e"
            "f"
      let expect = """* a
* - b
  - * c
    * d
  - * e
    * f"""
      check $test == $test
      check $test == expect