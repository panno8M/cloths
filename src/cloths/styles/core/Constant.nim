import cloths/sdk

type Constant* = ref object of Style
  ## Similar to Multiline, but will NOT apply styles under the style.
let constant* = Constant()

method apply(style: Constant; data: Data): Data = copy data

