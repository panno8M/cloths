import ./sdk

type Read* {.requiresinit.} = ref object of Style
  file*: File
  prompt*: string

proc read*(file: File; prompt: string = ""): Read = Read(file: file, prompt: prompt)

method apply(style: Read; data: Data): Data =
  if style.file == stdin:
    stdout.write style.prompt
    flushFile stdout
  style.file.readAll.clothfy.data

import style_markdown_OrderedList
import bundle_controller
styletest:
  suite"Read":
    test"simple":
      let test = weave &orderedList:
        cloth stdin.read("input> ")
      echo $test