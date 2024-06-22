import cloths/sdk

type Multiline* = ref object of Style
let multiline* = Multiline()

method apply(style: Multiline; data: Data): Data =
  if data.isString: return data
  new result
  for subcloth in data.subitems:
    let applied = apply(subcloth)
    if applied.len != 0:
      result.subitems.add cloth applied

styletest:
  import cloths/needle
  import Empty
  suite"Multiline":
    test"simple":
      let test = weave multiline:
        "abc"
        "def"
        "ghi"
      let expect = """abc
def
ghi"""
      check $test == $test
      check $test == expect

    test "empty":
      let test = cloth multiline
      let expect = ""
      check $test == $test
      check $test == expect

    test"nested":
      let test = weave multiline:
        "a"
        weave constant:
          "b"
          "c"
        cloth empty
        weave constant:
          "d"
          "e"
      let expect = """a
b
c
d
e"""
      check $test == $test
      check $test == expect