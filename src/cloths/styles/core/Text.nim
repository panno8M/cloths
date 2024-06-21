import cloths/sdk
import Join

type Text* = ref object of Style
let text* = Text()

let super = Join(delim: " ")

method apply(style: Text; data: Data): Data = apply(super, data)
