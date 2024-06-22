
when defined(styletest):
  echo ""
  echo "`d:styletest` was defined."
  echo "Run unit-test for each Style..."

  echo ""
  echo "[Core Styles]"

  import cloths/styles/core/Join
  import cloths/styles/core/Margin
  import cloths/styles/core/Multiline
  import cloths/styles/core/Order
  import cloths/styles/core/Prefix
  import cloths/styles/core/Tree
  import cloths/styles/core/Underline
  import cloths/styles/core/Unorder

  Join.styletest()
  Margin.styletest()
  Multiline.styletest()
  Order.styletest()
  Prefix.styletest()
  Tree.styletest()
  Underline.styletest()
  Unorder.styletest()

  echo ""
  echo "[Core Styles - Applications]"

  import cloths/styles/core/Indent

  Indent.styletest()

  echo ""
  echo "[Markdown Styles]"

  import cloths/styles/markdown/CheckBox

  CheckBox.styletest()

  echo ""
  echo "[algorithm Styles]"

  import cloths/styles/algorithm/Sort

  Sort.styletest()

  echo ""
  echo "[io Styles]"

  import cloths/styles/io/Read

  Read.styletest()