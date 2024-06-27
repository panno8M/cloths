import cloths/sdk
import cloths/styles/core/Multiline

type ClothsProofDefect* = object of CatchableError

type Proof* = ref object of Style
  lines*: Natural
  elements*: Natural

method apply*(style: Proof; data: Data): Data =
  result = multiline.apply(data)
  if style.elements != 0:
    if result.len < style.elements:
      raise newException(ClothsProofDefect, "element length of data is less than " & $style.elements)
  if style.lines != 0:
    if result.linelen < style.lines:
      raise newException(ClothsProofDefect, "line length of data is less than " & $style.lines)