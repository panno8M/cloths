import ./sdk

# Underline
# ---------
type Underline* = ref object of Style
  pattern*: string = "-"

proc makeline(length: int; pattern: string): string =
  result = newString(length)
  for i, ch in result.mpairs:
    ch = pattern[i mod pattern.len]

proc maxwidth(appliedData: Data): int =
  if appliedData.isString:
    return appliedData.str.len
  for subcloth in appliedData.subitems:
    result = max(result, subcloth.data.maxwidth)

proc underline(appliedData: Data; pattern: string): Data =
  new result
  result.subitems.add rendered_cloth appliedData
  result.subitems.add rendered_cloth makeline(appliedData.maxwidth, pattern)
#   if appliedData.isString:
#     result.subitems.add rendered_cloth data appliedData.str
#     result.subitems.add rendered_cloth data makeline(appliedData.str.len, pattern)
#   else:
#     for subcloth in appliedData.subitems:
#       result.subitems.add rendered_cloth underline(subcloth, pattern)

method apply(style: Underline; data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString:
    return underline(data, style.pattern)
  new result

  data.eachAppliedData(meta, subdata):
    result.subitems.add rendered_cloth underline(subdata, style.pattern)

styletest:
  suite"Underline":
    test"simple":
      let test = weave Underline():
        "ab"
        "cde"
        "f"
      let expect = """ab
--
cde
---
f
-"""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave Underline():
        "ab"
        weave constant:
          "cde"
          "f"
      let expect = """ab
--
cde
f
---"""
      check $test == $test
      check $test == expect

    test"nested":
      let test = weave Underline():
        weave Underline(pattern: "-*"):
          "abcdefg"
      let expect = """abcdefg
-*-*-*-
-------"""
      check $test == $test
      check $test == expect