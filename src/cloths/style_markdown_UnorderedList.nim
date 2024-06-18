import ./sdk
import ./style_core_Unorder

type UnorderedList* = ref object of Style
let unorderedList* = UnorderedList()

let super = Unorder(entry: "* ")

method apply(style: UnorderedList; data: Data): Data = apply(super, data)