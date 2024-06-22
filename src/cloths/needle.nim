import std/strutils
import std/sequtils
import std/macros
import sdk

proc deepcopy*(cloth: Cloth): Cloth
proc deepcopy(data: Data): Data =
  if unlikely(data.isNil): return
  if data.isString: return data data.str
  new result
  for subcloth in data.subitems:
    result.subitems.add deepcopy subcloth
proc deepcopy*(cloth: Cloth): Cloth =
  cloth_lowlevel(cloth.style, deepcopy cloth.data)

proc cloth*(style: Style; subitems: varargs[Cloth]): Cloth =
  cloth_lowlevel(style, data @subitems)

proc `$`*(cloth: Cloth): string =
  cloth.deepcopy.apply.eachline.toseq.join("\n")

func add*(cloth: Cloth; subitems: varargs[Cloth]) =
  cloth.data.subitems.add @subitems

template add(cloth: Cloth; args: varargs[untyped]): untyped = args

proc weave_impl(instance, body: NimNode; chain: bool): NimNode

macro weave*(style: Style; body): untyped =
  weave_impl(bindsym"cloth".newCall(style), body, true)

macro weave*(cloth: Cloth; body): untyped =
  weave_impl(cloth, body, false)

proc weave_impl(instance, body: NimNode; chain: bool): NimNode =
  let add = bindsym"add"
  let weave = bindsym"weave"
  let c = gensym(nskLet, "cloth")
  result = newNimNode (if chain: nnkStmtListExpr else: nnkStmtList)
  result.add quote do:
    let `c`: Cloth = `instance`
  for stmt in body:
    case stmt.kind
    of nnkIfStmt, nnkWhenStmt:
      for branch in stmt:
        branch[^1] = weave.newCall(c, branch[^1])
      result.add stmt
    of nnkForStmt, nnkWhileStmt:
      stmt[^1] = weave.newCall(c, stmt[^1])
      result.add stmt
    of nnkVarSection, nnkLetSection:
      result.add stmt
    else:
      result.add add.newCall(c, stmt)
  if chain:
    result.add c

converter clothfy*(text: string): Cloth {.noSideEffect.} =
  let data = new Data
  for line in text.splitLines():
    data.subitems.add cloth(line)
  cloth data
