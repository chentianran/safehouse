require 'resultParser'

# Takes the raw SQL data result hash and formats the data for use in the 
# systemDetails.haml template. Includes hardcoded, but easily changable,
# arrays that map each SQL data field to a location in the template and a
# human readable title.
class SystemViewParser
   #Modify title method to change title

   #Description box
   #Format for each field: [field, human readable title]
   @@descriptionFields = [ ['familydesc', 'Family Description' ],
                           ['desc', 'Description'] ]
   #Format for each field: [field, human readable title]
   @@cornerTableFields = [  ['dim', 'Dimension'], 
                           ['tdeg', 'Total Degree'], 
                           ['mvol', 'Mixed Volume'], 
                           ['emvol', 'Extended Mixed Volume'], 
                           ['soln_count_c', 'Isolated solutions'], 
                           ['soln_count_r', 'Isolated real solutions'] ]

   @@collapsibleBoxesFields = [['ref', 'Reference'],
                           ['eq_sym', 'Equations'],
                           ['eq_hps', 'Equations (HOM4PS format)'],
                           ['solns_c', 'Isolated solutions'],
                           ['solns_r', 'Isolated real solutions'],
                           ['comp', 'Components of positive dimensions']]

   @@boolFlagFields = [     ['posdim', 'Has positive dimensional components'],
                           ['open', 'Open problem'] ]

   def initialize(resultsHash)
      @queryResultHash = resultsHash
      @parser = ResultParser.new(resultsHash)
   end

   def getDescriptions()
      return @parser.titleData(@@descriptionFields)
   end

   def getCornerTableData()
      return @parser.titleData(@@cornerTableFields)
   end

   def getBoolReplacements()
      return @parser.replaceBools(@@boolFlagFields)
   end

   def getCollapsibleBoxesData()
      return @parser.titleData(@@collapsibleBoxesFields)
   end

   def getTitle()
      if @queryResultHash['longname'] == nil
         return @queryResultHash['name']
      else
         return @queryResultHash['longname']
      end
   end
end
