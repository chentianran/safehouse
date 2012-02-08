#!/bin/bash
tests=( "add hi" "set hi longname=hello" "set hi familyname=hi" "query -a" "query -a -f" "delete hi" "delete -f hi")
for test in "${tests[@]}"
do
   echo ruby admin.rb  $test
   ruby admin.rb $test
   echo 
done 
