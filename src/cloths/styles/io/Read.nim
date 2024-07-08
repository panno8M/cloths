import cloths/sdk
import cloths/needle

type Read* {.requiresinit.} = ref object of Style
  file*: File

proc read*(file: File): Read = Read(file: file)

method apply(style: Read; data: Data): Data =
  result = style.file.readAll.clothfy.data
  try:
    style.file.setFilePos(0)
  except IOError:
    discard

styletest:
  suite"Read":
    test"simple":
      let file = open("cloths.nimble")
      let test = cloth read file
      let expect = readFile("cloths.nimble")
      check $test == $test
      check $test == expect
    when isMainModule:
      test"stdin":
        let test = cloth read stdin
        let expect = "abc"
        check $test == $test
        check $test == expect
