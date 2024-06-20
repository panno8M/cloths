## Usage
## #####
##
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

## weave macro
## ###########
##
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

## Style List
## ##########
##
## `Core <cloths/style_core.html>`_ (imported)
## ===========================================
##
## `Indent <cloths/style_core_Indent.html>`_
## -----------------------------------------
##
## Insert specified number of space in front of each line.
##
## `Join <cloths/style_core_Join.html>`_
## -------------------------------------
##
## Connect each line with specified delimiter.
##
## `Margin <cloths/style_core_Margin.html>`_
## -----------------------------------------
##
## Insert specified thickness of blank line between each line.
##
## `Order <cloths/style_core_Order.html>`_
## ---------------------------------------
##
## | Insert specified text in front of each element.
## | To specify text, pass function that takes number of lines and return text.
##
## `Prefix <cloths/style_core_Prefix.html>`_
## -----------------------------------------
##
## Insert specified text in front of each line.
##
## `Text <cloths/style_core_Text.html>`_
## -------------------------------------
##
## Connect each line with an space.
##
## `Tree <cloths/style_core_Tree.html>`_
## -------------------------------------
##
## Insert directory-diagram signs in front of each element.
##
## `Underline <cloths/style_core_Underline.html>`_
## -----------------------------------------------
##
## | Insert specified pattern of line under each element.
## | If pattern is shorter than an element, it will be repeated.
##
## `Unorder <cloths/style_core_Unorder.html>`_
## -------------------------------------------
##
## | Insert same specified text in front of each element.
## | text is evaluated on instantiate it.
##
## `Controller <cloths/style_controller.html>`_ (imported)
## =======================================================
##
## `Concat <cloths/style_controller_Concat.html>`_
## -----------------------------------------------
##
## Concat whole elements to single data; then apply inner-Style to the data.
##
## `Merge <cloths/style_controller_Merge.html>`_
## ---------------------------------------------
##
## Take two Styles and apply them in a chain.
##
## `Then <cloths/style_controller_Then.html>`_
## -------------------------------------------
##
## Same as nested weaving.
##
## `Algorithm <cloths/style_algorithm.html>`_ (import required)
## ============================================================
##
## `Sort <cloths/style_algorithm_Sort.html>`_
## ------------------------------------------
##
## Sort elements. compare method is customizable.
##
## `IO <cloths/style_io.html>`_ (import required)
## ==============================================
##
## `Read <cloths/style_io_Read.html>`_
## -----------------------------------
##
## Read string from a File. stdin is also available.
##
## `Markdown <cloths/style_markdown.html>`_ (import required)
## ==========================================================
##
## `Check Box <cloths/style_markdown_CheckBox.html>`_
## --------------------------------------------------
##
## Insert "[[ ]] " or "[[x]] " in front of each element.
##
## `Ordered List <cloths/style_markdown_OrderedList.html>`_
## --------------------------------------------------------
##
## Insert "1. ", "2. ", ... in front of each element.
##
## `Quote <cloths/style_markdown_Quote.html>`_
## -------------------------------------------
##
## Insert "> " in front of each line.
##
## `Unordered List <cloths/style_markdown_UnorderedList.html>`_
## ------------------------------------------------------------
##
## Insert "* " in front of each element.

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

when defined(docgen):
  import ./cloths/style_algorithm
  import ./cloths/style_io
  import ./cloths/style_markdown