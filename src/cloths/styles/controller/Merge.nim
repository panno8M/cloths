import cloths/sdk

type Merge* = ref object of Style
  a, b: Style
proc merge*(a, b: Style): Merge = Merge(a: a, b: b)
template `&`*(a, b: Style): Merge = a.merge b

method apply(style: Merge; data: Data): Data =
  style.a.apply style.b.apply data