class ResultParser
   :hash

   def initialize(resultHash)
      @hash= resultHash
   end

   def replaceBools(fieldReplacements)
      output = Array[]
      fieldReplacements.each do |field, replacement|
         if @hash[field] == 1
            output.push(replacement)  
         end
      end
      return output
   end

   def titleData( fieldTitles ) 
      output = Array[]
      fieldTitles.each do |fieldTitle|
			field = fieldTitle[0]
			title = fieldTitle[1]
     	   data = @hash[field]
         if data != nil
            output.push(Array[title, data])  
         end
		end	
      return output
   end
end


