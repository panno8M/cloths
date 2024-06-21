import cloths/sdk
import std/algorithm

proc cmp*(a, b: Cloth): int =
  var iter_a = newIterator(a.data)
  var iter_b = newIterator(b.data)
  while result == 0:
    let ap = iter_a.next()
    let bp = iter_b.next()
    if nil in [ap, bp]: return
    result = cmp(ap[], bp[])


type Sort* = ref object of Style
  cmp*: proc(a, b: Cloth): int = cmp

let sort* = Sort(cmp: cmp)

method apply(style: Sort; data: Data): Data =
  result = multiline.apply(data)
  if unlikely(data.isNil) or data.isString: return
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
