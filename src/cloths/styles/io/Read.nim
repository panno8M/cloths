import cloths/sdk
import cloths/needle

type Read* {.requiresinit.} = ref object of Style
  file*: File
  prompt*: string

proc read*(file: File; prompt: string = ""): Read = Read(file: file, prompt: prompt)

method apply(style: Read; data: Data): Data =
  if style.file == stdin:
    stdout.write style.prompt
    flushFile stdout
  result = style.file.readAll.clothfy.data
  try:
    style.file.setFilePos(0)
  except IOError:
    discard
  if style.file == stdin:
    stdout.write "\n"
    flushFile stdout

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
        let test = cloth stdin.read("input(plz write: abc)> ")
        let expect = "abc"
        check $test == $test
        check $test == expect
