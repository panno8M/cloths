import cloths/sdk
import cloths/styles/core/Unorder

type UnorderedList* = ref object of Style
let unorderedList* = UnorderedList()

let super = Unorder(entry: "* ")

method apply(style: UnorderedList; data: Data): Data = apply(super, data)