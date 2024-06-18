## Cloths provides the way to process and structure string easily.
##
## This library separate text into Style and Data; and represent text with combination
## of these.
##
## Same as HTML that puts tags, it also puts Style instead of write "\\n" or fill with SPC.
##
## Like Nim's macro, Style is an transformer that receive Data and return new Data. So
## you can apply in a chain, put together, or expand function with Style.
runnableExamples:
  import cloths/style_markdown
  echo:
    weave multiline:
      "LIST:"
      weave Margin(thickness: 1) & indent(2) & orderedList:
        "foo"
        "bar"
        "baz"
      "END LIST"
  # output:
  # LIST:
  #   1. foo
  #
  #   2. bar
  #
  #   3. baz
  # END LIST

## `weave` is a very useful macro to build a cloth.
##
## ```
## weave multiline:
##   "foo"
##   "bar"
##   "baz"
## ```
##
## is same as:
##
## ```
## cloth(multiline, clothfy"foo", clothfy"bar", clothfy"baz")
## ```
##
## or,
##
## ```
## let cloth = cloth(multiline)
## cloth.add "foo"
## cloth.add "bar"
## cloth.add "baz"
## ```
##
## Additionaly, in weave, you can use if, when, for and while statements. e.g.:
##
## ```
## weave multiline:
##   if foo:
##     "bar"
##     "baz"
## ```
##
## will be expanded to:
##
## ```
## let cloth = cloth multiline
## if foo:
##   cloth.add "bar"
##   cloth.add "baz"
## ```
##
## and other statements are same. weave tryes to append `cloth.add` for each lines.
##
## If you do not needs this function, encircle with `block:` to avoid it.
##
## ```
## weave multiline:
##   if foo:
##     block:
##       var str = "bar"
##       (blah blah blah...)
##       str
##     "baz"
## ```
##

# SDK exportation #
# =================
import ./cloths/sdk

export sdk.Cloth
export sdk.Constant, sdk.Plain, sdk.Multiline, sdk.Empty, sdk.Ignore
export sdk.constant, sdk.plain, sdk.multiline, sdk.empty, sdk.ignore
export sdk.cloth, sdk.`$`, sdk.add, sdk.weave, sdk.clothfy

# Core Components #
# =================
import ./cloths/style_core; export style_core
import ./cloths/style_controller; export style_controller