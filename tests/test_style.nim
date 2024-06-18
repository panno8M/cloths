
when defined(styletest):
  echo ""
  echo "`d:styletest` was defined."
  echo "Run unit-test for each Style..."

  echo ""
  echo "[Core Styles]"

  import cloths/sdk
  import cloths/style_core_Unorder
  import cloths/style_core_Order
  import cloths/style_core_Prefix
  import cloths/style_core_Underline
  import cloths/style_core_Margin
  import cloths/style_core_Tree

  sdk.styletest()
  style_core_Unorder.styletest()
  style_core_Order.styletest()
  style_core_Prefix.styletest()
  style_core_Underline.styletest()
  style_core_Margin.styletest()
  style_core_Tree.styletest()

  echo ""
  echo "[Core Styles - Applications]"

  import cloths/style_core_Indent

  style_core_Indent.styletest()

  echo ""
  echo "[Markdown Styles]"

  import cloths/style_markdown_CheckBox

  style_markdown_CheckBox.styletest()