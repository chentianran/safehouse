
#format exponents and subscripts so they display correctly
#in LATEX
def filterExpAndSub(systems)
   systems.each do |system|
      if system["eq_sym"]!=nil
         #subscripts    
         system["eq_sym"].gsub!( /([[:alpha:]])(\d+)/, '\1_{\2}') 
         system["eq_sym"].gsub!( /\^(\d\d+)/, '^{\1}') 
         system["eq_sym"].delete!("\n") 
         system["eq_sym"].gsub!( /;/, " = 0\n") 
      end
   
   end
end

