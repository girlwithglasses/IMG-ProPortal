#!/bin/csh -fx
if "$1" == "" then
   echo "cp2sib.csh <dir>"
endif
set d=../$1
cp *.html *.css *.js *.jar $d
cp -r images $d
