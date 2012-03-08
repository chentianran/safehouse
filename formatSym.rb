require 'systemsDb.rb'
   #fields and keywords
   @@fields =[ 
               #['familydesc', 'Family Description' ],
               #['desc', 'Description'],
               ['dim', 'Dimension'], 
               ['tdeg', 'Total Degree'], 
               ['mvol', 'Mixed Volume'], 
               ['emvol', 'Extended Mixed Volume'],
               ['soln_count_c', 'Isolated solutions roots number'], 
               ['soln_count_r', 'Isolated real solutions roots number'],
               #['ref', 'Reference'],
               #['eq_sym', 'Equations'],
               #['eq_hps', 'Equations HOM4PS format'],
               ['solns_c', 'Isolated solutions roots'],
               ['solns_r', 'Isolated real solutions roots'],
               ['comp', 'Components of positive dimensions'],
               #['posdim', 'Has positive dimensional components'],
               #['open', 'Open problem']
            ]
if ARGV[0] == nil
   print "Usage: formatSym.rb SYM_FILE\n"
end

ARGV.each do |filename|
   #db = SystemsDb.new('systems.db') 
   
   #extract the system name as the filename
   systemName = filename.match(/(\w*)\.sym$/ )[1]
   
   #db.add(SystemsDb::SYSTEM_TABLE, systemName)

   symFile = File.new(filename)
   sym2File = File.new("sym2/#{systemName}.sym2","w")

   contents = symFile.read()

   #split into equation part and properties
   equation, properties = contents.split('}')
   #remove leading bracket
   equation.sub!(/\{/, "")

   sym2File << "{ #{equation} }\n"
   sym2File << "eq_sym=#{equation}\n"

   if properties != nil
      
      propertiesArr =[]
      properties.scan(/#\W*(.*)(?=$)/).each do |rawProp|
         propertiesArr.push(rawProp[0])
      end
     
      if propertiesArr.count > 0
         #description should be first, is special case
         
         sym2File << "# #{propertiesArr[0]}\n"
         sym2File << "desc=#{properties.gsub(/^#/,"")}\n"

      end

      if propertiesArr.count > 1
            #iterate over each line beginning with #
            propertiesArr[1..-1].each do |prop|
            #extrach the part without # and \n

            #simple algorithm to put the data into fields
            #will need to be verified
            bestGuess = ""
            bestGuessMatches = 0
            @@fields.each do |field, keywords|
               matches = 0
               keywords.split.each do |keyword|
                  keywordRegex = ""
                  if prop.match(/#{keyword}/i) != nil
                     matches += 1
                  end
               end
               if matches > bestGuessMatches
                  bestGuessMatches = matches
                  bestGuess = field
               end
            end
            print "\n"
            value = prop.match(/\d*(?=\W*$)/)[0].to_i
            sym2File << "# #{prop}\n"
            if value != nil and bestGuess != nil
               sym2File << "#{bestGuess}=#{value}\n"
            end
         end
      end
   end
   symFile.close
   sym2File.close
end

