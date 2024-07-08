## Needle - Cloths' weaving toolkit
## ################################

## `weave` Macro
## #############
##
## `weave` is a very useful macro to build a cloth.
##
## ```
## weave multiline:
##   "foo"
##   "bar"
##   "baz"
## ```
##
## That is same as:
##
## ```
## let cloth = cloth(multiline)
## cloth.add "foo"
## cloth.add "bar"
## cloth.add "baz"
## ```
##
## If a statement returns `Cloth` (or `string` that has to-Cloth converter), `cloth.add` will added.
##
## If that returns non-Cloth type or void, embedded as it is.
##
## ```
## weave multiline:
##   let foo = "foo"
##   foo
##   "bar"
##   "baz"
## ```
##
## means
##
## ```
## let cloth = cloth(multiline)
## let foo = "foo"
## cloth.add foo
## cloth.add "bar"
## cloth.add "baz"
## ```
##
## Additionaly, in weave, you can use if, (elif, else,) when, for and while statements. e.g.:
##
## ```
## weave multiline:
##   if foo:
##     "bar"
##     "baz"
## ```
##
## will be expanded to:
##
## ```
## let cloth = cloth multiline
## if foo:
##   cloth.weave:
##     "bar"
##     "baz"
## ```
##
## And other statements are same. `weave` inserts `cloth.weave` to inner-block.
##
## Nested control statement also works.
##
## ```
## weave text:
##   for s in ["a", "b", "c"]:
##     &"[{s}]"
##     for i in 1..3:
##       if i == 2: continue
##       s & $i
## # => [a] a1 a3 [b] b1 b3 [c] c1 c3
##
## #[
## let cloth = cloth text
## for s in ["a", "b", "c"]:
##   cloth.add(&"[{s}]")
##   for i in 1..3:
##     if i == 2: continue
##     cloth.add(s & $i)
## ]#
## ```

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

func add*(cloth: Cloth; subitem: Cloth) =
  cloth.data.subitems.add subitem

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
    of nnkIfStmt, nnkWhenStmt, nnkCaseStmt:
      for branch in stmt:
        branch[^1] = weave.newCall(c, branch[^1])
      result.add stmt
    of nnkTryStmt:
      stmt[0] = weave.newCall(c, stmt[0])
      for i, branch in stmt:
        if i == 0: continue
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
