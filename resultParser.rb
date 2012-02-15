class ResultParser
   :hash

   def initialize(resultHash)
      @hash= resultHash
   end

   def replaceBools(fields, strings)
      output = Array[]
      fields.each_with_index do |field, index|
         if @hash[field] == 1
            output.push(strings[index])  
         end
      end
      return output
   end

   def titleData(fields, titles) 
      output = Array[]
      fields.each_with_index do |field, index|
         data = @hash[field]
         if data != nil
            output.push(Array[titles[index], data])  
         end
      end
      return output
   end
end


