import std/strutils
import std/sequtils
import std/deques
import std/macros

## Cloths' Style Development Kit
## #############################
##
## This provides internal functionalities to develop custom Style.
## See built-in styles to know how to use each functionalities.

# Internal API #
# ==============

type
  Style* = ref object of RootObj
  Data* = ref object
    case isString*: bool
    of true:
      str*: string
    of false:
      subitems*: seq[Cloth]
  Cloth* = object
    style*: Style = nil
    data*: Data = nil


proc data*(str: string): Data = Data(isString: true, str: str)
proc data*(subitems: varargs[Cloth]): Data = Data(isString: false, subitems: @subitems)

proc cloth_lowlevel*(style: Style; data: Data): Cloth = Cloth(style: style, data: data)
proc cloth_lowlevel*(style: Style; str: string): Cloth = cloth_lowlevel(style, data(str))

const constant*: Style = nil
proc cloth*(data: Data): Cloth = cloth_lowlevel(constant, data)
proc cloth*(str: string): Cloth = cloth_lowlevel(constant, data str)


proc len*(data: Data): int =
  if unlikely(data.isNil): 0
  elif data.isString: 1
  else:
    data.subitems.len
proc linelen*(data: Data): int =
  if unlikely(data.isNil): return 0
  if data.isString: return 1
  for subcloth in data.subitems:
    result += linelen subcloth.data

method apply*(style: Style; data: Data): Data {.base.} = (discard)

proc apply*(cloth: Cloth): Data =
  if cloth.style == constant: cloth.data
  else: cloth.style.apply(cloth.data)

type Iterator* = object
  queue: Deque[Data]

proc newIterator*(data: Data): Iterator =
  # if primary data is empty, queue.len will be 0.
  if unlikely(data.isNil): return
  if data.isString:
    result.queue.addLast data
  else:
    for i in countdown(data.subitems.high, 0):
      result.queue.addLast data.subitems[i].data

proc next*(iter: var Iterator): ptr string =
  if iter.queue.len == 0: return
  let data = iter.queue.popLast
  if data.isString:
    return addr data.str
  else:
    for i in countdown(data.subitems.high, 0):
      iter.queue.addLast data.subitems[i].data
    iter.next

iterator eachline*(data: Data): var string =
  var iter = newIterator(data)
  while iter.queue.len != 0:
    yield iter.next()[]

iterator eachpair*(data: var Data): tuple[i_line: int; line: var string] =
  if data.isString:
    yield (0, data.str)
  else:
    var i_line: int
    for line in data.eachline:
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
    if next.isNil or next.len == 0: continue

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

# Style Test #
# ============

# Note:
# **Don't** forget to stringify at least twice to guarantee result-identity.
# For standard use, style-application will occur when every call `$`.
# Therefore, it is necessary to guarantee that the result will
# not change no matter how many times the stringification is repeated.

macro styletest*(body) =
  let testentry = ident"styletest"

  let testblock = newStmtList quote do:
    import std/unittest

  let testbody = newStmtList()
  for line in body:
    case line.kind
    of nnkImportStmt:
      testblock.add line
    else:
      testbody.add line

  testblock.add quote do:
    proc `testentry`* =
      `testbody`
  result = quote do:
    when isMainModule or defined(styletest):
      `testblock`
    when isMainModule:
      `testentry`()