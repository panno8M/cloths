import cloths/sdk

type Concat* {.requiresInit.} = ref object of Style
  a*: Style
proc concat*(a: Style): Concat = Concat(a: a)
template `&`*(a: Style): Concat = concat a

method apply(style: Concat; data: Data): Data =
  if unlikely(data.isNil): discard
  elif data.isString:
    result = data
  else:
    new result
    data.eachAppliedData(meta, subdata):
      if subdata.isString:
        result.subitems.add cloth subdata
      else:
        result.subitems.add subdata.subitems
  style.a.apply result