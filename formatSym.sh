#/bin/bash
for file in `ls equations`
do
   name=`echo $file |cut -d. -f1 ` 
   desc=`grep ^# equations/$file | sed s/^#[^a-zA-Z0-9]*//g`  
   #ruby ./admin.rb add $name
   #echo $desc
   ruby ./admin.rb set $name raw="$desc"
done
