# Package

version       = "0.1.0"
author        = "Kaushal Modi"
description   = "Emacs-Lisp equivalent procs and templates in Nim"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.0"

import ospaths # for `/`
import strutils # for `%`
let
  pkgName = "nimy_lisp"
  srcFile = thisDir() / "src" / (pkgName & ".nim")

task test, "Run tests via 'nim doc' and runnableExamples":
  exec("nim doc " & srcFile)

task docs, "Deploy doc html + search index to public/ directory":
  let
    deployDir = thisDir() / "public"
    deployHtmlFile = deployDir / "index.html"
    deployIdxFile = deployDir / (pkgName & ".idx")
    deployJsFile = deployDir / "dochack.js"
    genDocCmd = "nim doc --index:on -o:$1 $2" % [deployHtmlFile, srcFile]
    sedCmd = "sed -i 's|" & pkgName & r"\.html|index.html|' " & deployIdxFile
    genTheIndexCmd = "nim buildIndex -o:$1/theindex.html $1" % [deployDir]
    docHackJsSource = "http://nim-lang.github.io/Nim/dochack.js" # devel docs dochack.js
  mkDir(deployDir)
  exec(genDocCmd)
  # Hack: replace pkgName.html with index.html in the .idx file
  echo "[dbg sed cmd] " & sedCmd
  exec(sedCmd)
  exec(genTheIndexCmd)
  if not fileExists(deployJsFile):
    withDir deployDir:
      exec("curl -LO " & docHackJsSource)
