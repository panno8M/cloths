import cloths/sdk

type
  TreeBranchToken* = enum
    tbtSplt
    tbtEdge
    tbtLeaf
    tbtNone
  TreeBranch* = proc(token: TreeBranchToken): string
  Tree* {.requiresInit.} = ref object of Style
    branch*: TreeBranch

proc treeBranch*(token: TreeBranchToken): string =
  case token
  of tbtSplt: "├─ "
  of tbtEdge: "│  "
  of tbtLeaf: "└─ "
  of tbtNone: "   "
let tree* = Tree(branch: treeBranch)

method apply(style: Tree; data: Data): Data =
  if unlikely(data.isNil): return
  let leaf = style.branch(tbtLeaf)
  if data.isString: return data(leaf & data.str)
  let
    splt = style.branch(tbtSplt)
    edge = style.branch(tbtEdge)
    none = style.branch(tbtNone)
  new result

  data.eachAppliedData(meta, subdata):
    for i_line, line in subdata.eachpair:
      let token =
        if meta.isLastItem:
          if i_line == 0: leaf
          else:           none
        else:
          if i_line == 0: splt
          else:           edge
      line = token & line
    result.subitems.add cloth subdata

styletest:
  import cloths/needle
  import Multiline, Empty
  suite"Tree":
    test"single":
      let test = weave tree:
        "a"
      let expect = "└─ a"
      check $test == $test
      check $test == expect

    test"empty":
      let test = cloth tree
      let expect = ""
      check $test == $test
      check $test == expect

    test"multiline":
      let test = weave tree:
        "a"
        "b"
        "c"
      let expect = """
├─ a
├─ b
└─ c"""
      check $test == $test
      check $test == expect

    test"inner-multiline":
      let test = weave tree:
        "a"
        weave constant:
          "b"
          "c"
        "d"
      let expect = """
├─ a
├─ b
│  c
└─ d"""
      check $test == $test
      check $test == expect

    test"inner-empty":
      let test = weave tree:
        "a"
        cloth empty
        "b"
      let expect = """
├─ a
└─ b"""
      check $test == $test
      check $test == expect

    test"nested-tree":
      let test = weave tree:
        "a"
        weave multiline:
          "b"
          weave tree:
            "c"
            "d"
        weave multiline:
          "e"
          weave tree:
            "f"
            "g"
      let expect = """
├─ a
├─ b
│  ├─ c
│  └─ d
└─ e
   ├─ f
   └─ g"""
      check $test == $test
      check $test == expect
