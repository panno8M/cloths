import ./sdk
import std/algorithm

proc getline*(a: Cloth; i: int): tuple[linelen: int; str: string] =
  if a.data.isString:
    return (1, a.data.str)

  var diff: int
  for subcloth in a.data.subitems:
    (diff, result.str) = subcloth.getline(i - result.linelen)
    result.linelen += diff
    if i < result.linelen: return

proc cmp*(a, b: Cloth): int =
  var i: int
  while result == 0:
    let (ia, a) = a.getline(i)
    let (ib, b) = b.getline(i)
    if ia != ib: return
    result = cmp(a, b)
    inc i


type Sort* = ref object of Style
  cmp*: proc(a, b: Cloth): int = cmp

let sort* = Sort(cmp: cmp)

method apply(style: Sort; data: Data): Data =
  result = multiline.apply(data)
  if data.isString: return
  result.subitems.sort(style.cmp)

styletest:
  suite"Sort":
    test"simple":
      let test = weave sort:
        "bbb"
        "aaa"
        "ddd"
        "ccc"
      let expect = """aaa
bbb
ccc
ddd"""
      check $test == $test
      check $test == expect
    test"complex":
      let test = weave sort:
        "ddd"
        weave constant:
          "bbb"
        cloth empty
        weave constant:
          "ccc"
        weave constant:
          "aaa"
          "111"
        weave constant:
          "aaa"
      let expect = """aaa
111
aaa
bbb
ccc
ddd"""
      check $test == $test
      check $test == expect
