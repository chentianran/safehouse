require 'systemsDb.rb'
   #fields and keywords
   @@fields =[ ['familydesc', 'Family Description' ],
               ['desc', 'Description'],
               ['dim', 'Dimension'], 
               ['tdeg', 'Total Degree'], 
               ['mvol', 'Mixed Volume'], 
               ['soln_count_c', 'Isolated solutions roots number'], 
               ['soln_count_r', 'Isolated real solutions roots number'],
               ['ref', 'Reference'],
               ['eq_sym', 'Equations'],
               ['eq_hps', 'Equations HOM4PS format'],
               ['solns_c', 'Isolated solutions roots'],
               ['solns_r', 'Isolated real solutions roots'],
               ['comp', 'Components of positive dimensions'],
               ['posdim', 'Has positive dimensional components'],
               ['open', 'Open problem'] ]

if ARGV[0] == nil
   print "Usage: formatSym.rb SYM_FILE\n"
else
   symFile = File.new(ARGV[0])
   contents = symFile.read()
   #split into equation part and properties
   equation, properties = contents.split('}')
   #remove leading bracket
   equation.sub!(/\{/, "")
   print equation

   #iterate over each line beginning with #
   properties.scan(/#\W*(.*)$/)[1..-1].each do |rawProp|
      #extrach the part without # and \n
      prop = rawProp[0]
      print prop

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
      print "#{bestGuess}=#{value}"
      print "\n"

   end
end

