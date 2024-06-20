import std/strutils
import std/sequtils
import std/deques
import std/macros

## Cloths' Development Kit
## This provides internal functionalities to develop custom Style.
## See built-in styles to know how to use each functionalities.

# Internal API #
# ==============

type
  Style* {.requiresInit.} = ref object of RootObj
  Data* = object
    case isString*: bool
    of true:
      str*: string
    of false:
      subitems*: seq[Cloth]
  Cloth* = ref object
    style*: Style
    data*: Data


proc data*(str: string): Data = Data(isString: true, str: str)
proc data*(subitems: varargs[Cloth]): Data = Data(isString: false, subitems: @subitems)

proc cloth_lowlevel*(style: Style; data: Data): Cloth = Cloth(style: style, data: data)
proc cloth_lowlevel*(style: Style; str: string): Cloth = cloth_lowlevel(style, data(str))

proc rendered_cloth*(data: Data): Cloth = cloth_lowlevel(nil, data)
proc rendered_cloth*(str: string): Cloth = cloth_lowlevel(nil, data str)


proc len*(data: Data): int =
  if data.isString: 1
  else:
    data.subitems.len

proc copy*(cloth: Cloth): Cloth
proc copy*(data: Data): Data =
  if data.isString: return data
  for subcloth in data.subitems:
    result.subitems.add copy subcloth
proc copy*(cloth: Cloth): Cloth =
  if cloth.isNil: return
  cloth_lowlevel(cloth.style, copy cloth.data)

method apply*(style: Style; data: Data): Data {.base.} = copy data

proc apply*(cloth: Cloth): Data =
  if cloth.isNil: return
  if cloth.style.isNil: copy cloth.data
  else: cloth.style.apply(cloth.data)

iterator eachline*(data: Data): string =
  var queue = @[addr data].toDeque
  while queue.len != 0:
    let data = queue.popLast
    if data.isString:
      yield data.str
    else:
      for i in countdown(data.subitems.high, 0):
        queue.addLast addr data.subitems[i].data

iterator eachline*(data: var Data): var string =
  var queue = @[addr data].toDeque
  while queue.len != 0:
    let data = queue.popLast
    if data.isString:
      yield data.str
    else:
      for i in countdown(data.subitems.high, 0):
        queue.addLast addr data.subitems[i].data

iterator eachpair*(data: var Data): tuple[i_line: int; line: var string] =
  if data.isString:
    yield (0, data.str)
  else:
    var i_line: int
    for subcloth in data.subitems.mitems:
      for line in subcloth.data.eachline:
        yield(i_line, line)
        inc i_line

template eachAppliedData*(data: Data; metatoken, datatoken, body): untyped =
  var `datatoken` {.inject.}: Data
  var next: Data
  var `metatoken` {.inject.} = (
    isLastItem: false,
    index: -1
  )

  for subcloth in data.subitems:
    next = apply subcloth
    if next.len == 0: continue

    if likely(`metatoken`.index != -1):
      body
    inc `metatoken`.index
    `datatoken` = next
  `metatoken`.isLastItem = true
  if likely(`metatoken`.index != -1):
    body

# Utilities #
# ===========

proc whitespace*(length: Natural): string = ' '.repeat(length)

# Built-in Styles #
# =================

# Constant #
# ----------
type Constant* = ref object of Style
  ## Similar to Multiline, but will NOT apply the style.
let constant* = Constant()
# use Style.apply

# Plain/MultiLine #
# -----------------
type Plain* = ref object of Style
let plain* = Plain()
type MultiLine* = Plain
let multiline* = Multiline()

method apply(style: Plain; data: Data): Data =
  if data.isString: return data
  for subcloth in data.subitems:
    let applied = apply(subcloth)
    if applied.len != 0:
      result.subitems.add rendered_cloth applied

# Empty/Ignore #
# --------------
type Empty* = ref object of Style
let empty* = Empty()
type Ignore* = Empty
let ignore* = Ignore()

method apply(style: Ignore; data: Data): Data = discard

# For Standard Use #
# ==================

proc cloth*(style: Style; subitems: varargs[Cloth]): Cloth =
  cloth_lowlevel(style, data @subitems)

proc `$`*(cloth: Cloth): string =
  if cloth.isNil: return
  cloth.apply.eachline.toseq.join("\n")

func add*(cloth: Cloth; subitems: varargs[Cloth]) =
  cloth.data.subitems.add @subitems

proc weave_impl(instance, body: NimNode; chain: bool): NimNode =
  let add = bindsym"add"
  let c = gensym(nskLet, "cloth")
  result = newNimNode (if chain: nnkStmtListExpr else: nnkStmtList)
  result.add quote do:
    let `c`: Cloth = `instance`
  for stmt in body:
    case stmt.kind
    of nnkIfStmt, nnkWhenStmt:
      for branch in stmt:
        case branch.kind
        of nnkElifBranch:
          for i in 0..<branch[1].len:
            branch[1][i] = add.newCall(c, branch[1][i])
        of nnkElse:
          for i in 0..<branch[0].len:
            branch[0][i] = add.newCall(c, branch[0][i])
        else: discard
      result.add stmt
    of nnkForStmt, nnkWhileStmt:
      for i in 0..<stmt[^1].len:
        stmt[^1][i] = add.newCall(c, stmt[^1][i])
      result.add stmt

    else:
      result.add add.newCall(c, stmt)
  if chain:
    result.add c

macro weave*(style: Style; body): untyped =
  weave_impl(bindsym"cloth".newCall(style), body, true)

macro weave*(cloth: Cloth; body): untyped =
  weave_impl(cloth, body, false)

converter clothfy*(text: string): Cloth {.noSideEffect.} =
  var data: Data
  for line in text.splitLines():
    data.subitems.add rendered_cloth(line)
  rendered_cloth data

# Style Test #
# ============

# Note:
# **Don't** forget to stringify at least twice to guarantee result-identity.
# For standard use, style-application will occur when every call `$`.
# Therefore, it is necessary to guarantee that the result will
# not change no matter how many times the stringification is repeated.

template styletest*(body) =
  when isMainModule or defined(styletest):
    import std/unittest
    proc styletest* =
      body
  when isMainModule:
    styletest()

styletest:
  suite"Ignore (Empty)":
    test"simple":
      let test = weave ignore:
          "abc"
          "def"
          "ghi"
      let expect = ""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave ignore:
          "abc"
          weave constant:
            "def"
            "ghi"
      let expect = ""
      check $test == $test
      check $test == expect

  suite"Multiline (Plain)":
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