import cloths/sdk
import cloths/styles/core/Unorder

type CheckBox* {.requiresInit.} = ref object of Style
  checked*: bool
let checkbox*: array[bool, CheckBox] = [CheckBox(checked: false), CheckBox(checked: true)]

let super: array[bool, Unorder] = [Unorder(entry: "[ ] "), Unorder(entry: "[x] ")]

method apply(style: CheckBox; data: Data): Data = apply(super[style.checked], data)

styletest:
  import cloths/needle
  import cloths/styles/core/Multiline
  suite"CheckBox":
    test"simple":
      let test = weave multiline:
        weave checkbox[false]:
          "False"
        weave checkbox[true]:
          "True"
      let expect = """
[ ] False
[x] True"""
      check $test == $test
      check $test == expect