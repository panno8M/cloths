import cloths/sdk
import cloths/styles/core/Prefix

type Quote* = ref object of Style
let quote* = Quote()

let super = Prefix(prefix: "> ")

method apply(style: Quote; data: Data): Data = apply(super, data)