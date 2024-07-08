import cloths/sdk

from std/strutils import repeat

type OrderEntry* = proc(idx: Positive): string
type Order* {.requiresInit.} = ref object of Style
  entry*: OrderEntry

proc roman*(num: Positive): string =
  const table: array[4, array['0'..'9', string]] = [
    ["", "M", "MM", "MMM", ""  , "" , ""  , ""   , ""    , ""  ],
    ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
    ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
    ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
  ]
  if num >= 4000: raise newException(OverflowDefect, "num MUST be less than 4000.")
  var n = $num
  n = '0'.repeat(4 - n.len) & n
  for i in 0..3:
    result.add table[i][n[i]]
template orderIdx*(body): Order =
  Order(entry: proc(idx {.inject.}: Positive): string = `body`)

method apply(style: Order; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return data(style.entry(1) & data.str)
  new result

  data.eachAppliedData(meta, subdata):
    let entry = style.entry(meta.index.succ)
    let indent = sdk.whitespace(entry.len)

    for i_line, line in subdata.eachpair:
      line =
        if i_line == 0: entry  & line
        else:           indent & line

    result.subitems.add cloth subdata

styletest:
  import std/strformat
  import cloths/needle
  import Empty
  suite"Order":
    test"simple":
      let test = weave orderIdx(&"{idx}. "):
          "abc"
          "def"
          "ghi"
      let expect = """
1. abc
2. def
3. ghi"""
      check $test == $test
      check $test == expect

    test "empty":
      let test = cloth orderIdx(&"{idx}. ")
      let expect = ""
      check $test == $test
      check $test == expect

    test "inner-empty":
      let test = weave orderIdx(&"{idx}. "):
        cloth empty
        "a"
        cloth empty
        "b"
        cloth empty
        "c"
        cloth empty

      let expect = """
1. a
2. b
3. c"""
      check $test == $test
      check $test == expect

    test "complex":
      let test = weave orderIdx(&"{idx}. "):
        "a"
        weave orderIdx(&"{idx}. "):
          "b"
          cloth orderIdx(&"{idx}. ")
          weave orderIdx(&"{idx}. "):
            "c"
            "d"
          weave orderIdx(&"{idx}. "):
            "e"
            "f"
      let expect = """
1. a
2. 1. b
   2. 1. c
      2. d
   3. 1. e
      2. f"""
      check $test == $test
      check $test == expect