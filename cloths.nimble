# Package

version       = "1.0.0"
author        = "la .panon."
description   = "Cloths provides the way to process and structure string easily."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 2.0.0"

task docgen, "generate HTML documentation":
  exec "nim doc --project --index:on -o:docs -d:docgen src/cloths.nim"
