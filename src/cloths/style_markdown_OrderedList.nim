import ./sdk
import ./style_core_Order

type OrderedList* = ref object of Style
let orderedList* = OrderedList()

let super = orderIdx($idx & ". ")

method apply(style: OrderedList; data: Data): Data = apply(super, data)