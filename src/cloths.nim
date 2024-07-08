## Overview
## ########
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
  import cloths/styles/markdown
  echo:
    weave multiline:
      "LIST:"
      weave Margin(thickness: 1) & Indent(level: 2) & orderedList:
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

## Basic Usage
## ###########
##
## see `Needle <cloths/needle.html>`_.

## Style Development Guide
## #######################
##
## see `SDK <cloths/sdk.html>`_.

## Built-in Style List
## ###################
##
## `Core <cloths/styles/core.html>`_ (imported)
## ============================================
##
## `Empty <cloths/styles/core/Empty.html>`_
## ----------------------------------------
##
## Ignore elements and return empty cloth.
##
## `Indent <cloths/styles/core/Indent.html>`_
## ------------------------------------------
##
## Insert specified number of space in front of each line.
##
## `Join <cloths/styles/core/Join.html>`_
## --------------------------------------
##
## Connect each line with specified delimiter.
##
## `Margin <cloths/styles/core/Margin.html>`_
## ------------------------------------------
##
## Insert specified thickness of blank line between each line.
##
## `Multiline <cloths/styles/core/Multiline.html>`_
## ------------------------------------------------
##
## Basic style that applies every styles under it.
##
## `Order <cloths/styles/core/Order.html>`_
## ----------------------------------------
##
## | Insert specified text in front of each element.
## | To specify text, pass function that takes number of lines and return text.
##
## `Prefix <cloths/styles/core/Prefix.html>`_
## ------------------------------------------
##
## Insert specified text in front of each line.
##
## `Text <cloths/styles/core/Text.html>`_
## --------------------------------------
##
## Connect each line with an space.
##
## `Tree <cloths/styles/core/Tree.html>`_
## --------------------------------------
##
## Insert directory-diagram signs in front of each element.
##
## `Underline <cloths/styles/core/Underline.html>`_
## ------------------------------------------------
##
## | Insert specified pattern of line under each element.
## | If pattern is shorter than an element, it will be repeated.
##
## `Unorder <cloths/styles/core/Unorder.html>`_
## --------------------------------------------
##
## | Insert same specified text in front of each element.
## | text is evaluated on instantiate it.
##
## `Controller <cloths/styles/controller.html>`_ (imported)
## ========================================================
##
## `Concat <cloths/styles/controller/Concat.html>`_
## ------------------------------------------------
##
## Concat whole elements to single data; then apply inner-Style to the data.
##
## `Merge <cloths/styles/controller/Merge.html>`_
## ----------------------------------------------
##
## Take two Styles and apply them in a chain.
##
## `Then <cloths/styles/controller/Then.html>`_
## --------------------------------------------
##
## Same as nested weaving.
##
## `Exception <cloths/styles/exception.html>`_ (import required)
## =============================================================
##
## `Proof <cloths/styles/exception/Proof.html>`_
## ---------------------------------------------
##
## Raise an exception if applied data do not meet specified conditions.
##
## `Transact <cloths/styles/exception/Transact.html>`_
## ---------------------------------------------------
##
## Is exception raised while applying, return empty data. Return applied data if not.
##
## `Algorithm <cloths/styles/algorithm.html>`_ (import required)
## =============================================================
##
## `Sort <cloths/styles/algorithm/Sort.html>`_
## -------------------------------------------
##
## Sort elements. compare method is customizable.
##
## `IO <cloths/styles/io.html>`_ (import required)
## ===============================================
##
## `Read <cloths/styles/io/Read.html>`_
## ------------------------------------
##
## Read string from a File. stdin is also available.
##
## `Markdown <cloths/styles/markdown.html>`_ (import required)
## ===========================================================
##
## `Check Box <cloths/styles/markdown/CheckBox.html>`_
## ---------------------------------------------------
##
## Insert "[[ ]] " or "[[x]] " in front of each element.
##
## `Ordered List <cloths/styles/markdown/OrderedList.html>`_
## ---------------------------------------------------------
##
## Insert "1. ", "2. ", ... in front of each element.
##
## `Quote <cloths/styles/markdown/Quote.html>`_
## --------------------------------------------
##
## Insert "> " in front of each line.
##
## `Unordered List <cloths/styles/markdown/UnorderedList.html>`_
## -------------------------------------------------------------
##
## Insert "* " in front of each element.

from cloths/sdk import Cloth; export Cloth
import cloths/needle; export needle

import cloths/styles/core; export core
import cloths/styles/controller; export controller

when defined(docgen):
  import cloths/styles/algorithm
  import cloths/styles/exception
  import cloths/styles/io
  import cloths/styles/markdown