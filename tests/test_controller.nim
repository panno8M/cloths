import cloths

import std/unittest

from strformat import `&`
let data = @["a", "b", "c"]

suite"Then":
  test"simple":
    # It is an shorthand for:
    # weave orderIdx(&"i.{idx}. "):
    #   weave orderIdx(&"ii.{idx}. "):
    #     weave orderIdx(&"iii.{idx}. "):
    #       for datum in data: datum
    let test = weave orderIdx(&"i.{idx}. ") >> orderIdx(&"ii.{idx}. ") >> orderIdx(&"iii.{idx}. "):
      for datum in data: datum
    let expect = """i.1. ii.1. iii.1. a
           iii.2. b
           iii.3. c"""
    check $test == $test
    check $test == expect

suite"Merge":
  test"simple":
    # Merge styles and apply those to same subcloths at same time.
    let test = weave orderIdx(&"i.{idx}. ") & orderIdx(&"ii.{idx}. ") & orderIdx(&"iii.{idx}. "):
      for datum in data: datum
    let expect = """i.1. ii.1. iii.1. a
i.2. ii.2. iii.2. b
i.3. ii.3. iii.3. c"""
    check $test == $test
    check $test == expect

suite"Concat":
  test"simple":
    let test = weave &orderIdx(&"i.{idx}. "):
      weave orderIdx(&"ii.{idx}. "):
        for datum in data: datum
      weave orderIdx(&"iii.{idx}. "):
        for datum in data: datum
    let expect = """i.1. ii.1. a
i.2. ii.2. b
i.3. ii.3. c
i.4. iii.1. a
i.5. iii.2. b
i.6. iii.3. c"""
    check $test == $test
    check $test == expect