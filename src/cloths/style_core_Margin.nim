import ./sdk

type Margin* = ref object of Style
  thickness*: Natural = 1

proc margin(thickness: Natural): Cloth =
  var data: Data
  data.subitems = newSeqOfCap[Cloth](thickness)
  for _ in 1..thickness:
    data.subitems.add rendered_cloth""
  rendered_cloth data

method apply(style: Margin; data: Data): Data =
  if data.isString: return data
  data.eachAppliedData(meta, subdata):
    result.subitems.add rendered_cloth subdata
    if not meta.isLastItem:
      result.subitems.add margin(style.thickness)

styletest:
  suite"Margin":
    test"single":
      let test = weave Margin(thickness: 1):
        "abc"
      let expect = "abc"
      check $test == $test
      check $test == expect

    test"empty":
      let test = cloth Margin(thickness: 1)
      let expect = ""
      check $test == $test
      check $test == expect

    test"multiline":
      let test = weave Margin(thickness: 1):
        "abc"
        "def"
        "ghi"
      let expect = """abc

def

ghi"""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave Margin(thickness: 1):
        "abc"
        weave constant:
          "def"
          "ghi"
        "jkl"
      let expect = """abc

def
ghi

jkl"""
      check $test == $test
      check $test == expect

    test"inner-empty":
      let test = weave Margin(thickness: 1):
        "abc"
        cloth empty
        "def"
      let expect = """abc

def"""
      check $test == $test
      check $test == expect

    test"thickness":
      let test = weave Margin(thickness: 2):
        "abc"
        "def"
        "ghi"
      let expect = """abc


def


ghi"""
      check $test == $test
      check $test == expect

    test"thickness(default)":
      let test = weave Margin():
        "abc"
        "def"
        "ghi"
      let expect = """abc

def

ghi"""
      check $test == $test
      check $test == expect