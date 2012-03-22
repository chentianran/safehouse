#various utility functions for cleaningup up fields in the db

#Remove all of the properties that we have read into 
#property fields from the description
def removePropsInDesc(systems)
   systems.each do |system|
      if system["desc"]!=nil
         system["desc"].sub!(/^\s*mixed volume\s*:\s*\d*\s*/i,"")
         system["desc"].sub!(/^\s*extended mixed volume\s*:\s*\d*\s*/i,"")
         system["desc"].sub!(/^\s*number of roots\s*:\s*\d*\s*/i,"")
         system["desc"].sub!(/^\s*number of real roots\s*:\s*\d*\s*/i,"")
      end
   end
end

#removes spaces and (, ) from the beginning and end of 
#the description field
def cleanDesc(systems)
   systems.each do |system|
      if system["desc"]!=nil
         system["desc"].gsub!(/'/,"''")
         system["desc"].strip!
         system["desc"].sub!(/\A\(/,"")
         system["desc"].sub!(/\A,/,"")
         system["desc"].sub!(/\)\Z/,"")
         system["desc"].strip!
      end
   end
end
