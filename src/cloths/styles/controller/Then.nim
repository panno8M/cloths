import cloths/sdk

type Then* = ref object of Style
  a, b: Style
proc then*(a, b: Style): Then = Then(a: a, b: b)
template `>>`*(a, b: Style): Then = a.then b

method apply(style: Then; data: Data): Data =
  style.a.apply data cloth style.b.apply data