#!/bin/bash
tests=( "add hi" "set hi longname=hello" "set hi familyname=hi" "query -a" "query -a -f" "delete hi" "delete -f hi")
for test in "${tests[@]}"
do
   echo ruby -rubygems admin.rb  $test
   ruby -rubygems admin.rb $test
   echo 
done 
