import cloths/sdk
import cloths/styles/core/Multiline

type Transact* = ref object of Style
let transact* = Transact()

method apply*(style: Transact; data: Data): Data =
  try:
    return multiline.apply(data)
  except:
    discard