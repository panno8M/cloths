import ./sdk

type Prefix* = ref object of Style
  prefix*: string = "# "

method apply(style: Prefix; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return data(style.prefix & data.str)
  new result

  data.eachAppliedData(meta, subdata):
    for line in subdata.eachline:
      line = style.prefix & line

    result.subitems.add rendered_cloth subdata

styletest:
  suite"Prefix":
    test"simple":
      let test = weave Prefix():
          "abc"
          "def"
          "ghi"
      let expect = """# abc
# def
# ghi"""
      check $test == $test
      check $test == expect

    test "empty":
      let test = cloth Prefix()
      let expect = ""
      check $test == $test
      check $test == expect

    test "inner-empty":
      let test = weave Prefix():
        cloth empty
        "a"
        cloth empty
        "b"
        cloth empty
        "c"
        cloth empty

      let expect = """# a
# b
# c"""
      check $test == $test
      check $test == expect

    test "complex":
      let test = weave Prefix():
        "a"
        weave Prefix(prefix: "- "):
          "b"
          cloth Prefix()
          weave Prefix(prefix: "> "):
            "c"
            "d"
          weave Prefix(prefix: ">>"):
            "e"
            "f"
      let expect = """# a
# - b
# - > c
# - > d
# - >>e
# - >>f"""
      check $test == $test
      check $test == expect