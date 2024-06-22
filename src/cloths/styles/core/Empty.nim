import cloths/sdk

type Empty* = ref object of Style
let empty* = Empty()

method apply(style: Empty; data: Data): Data = discard

styletest:
  import cloths/needle
  suite"Empty":
    test"simple":
      let test = weave empty:
          "abc"
          "def"
          "ghi"
      let expect = ""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave empty:
          "abc"
          weave constant:
            "def"
            "ghi"
      let expect = ""
      check $test == $test
      check $test == expect