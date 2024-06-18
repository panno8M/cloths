import ./sdk

type Concat* = ref object of Style
  a*: Style
proc concat*(a: Style): Concat = Concat(a: a)
template `&`*(a: Style): Concat = concat a

method apply(style: Concat; data: Data): Data =
  if data.isString:
    result = data
  else:
    data.eachAppliedData(meta, subdata):
      if subdata.isString:
        result.subitems.add rendered_cloth subdata
      else:
        result.subitems.add subdata.subitems
  style.a.apply result