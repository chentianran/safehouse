require 'sinatra'
require 'sqlite3'
require 'haml'
require 'polySysDb'
require 'resultParser'

def replaceBools(fieldMap)

   #Some fields are a boolean value, and will be replaced with strings
   boolSubs = Array[Array["posdim", "Has positive dimensions"]] #,Array["open", "Is unsolved"]]

   output = Array[]
   boolSubs.each do |field, str|
      if fieldMap[field] == 1
         #delete field from map
         output.push(str)  
      end
      fieldMap.delete(field)
   end
   return output
end

helpers do
  def partial( page, variables={} )
      haml page.to_sym, {layout=>false}, variables
  end
end

#initialize database
databaseFile = "polysys.db"
if ARGV.count > 0
   databaseFile = ARGV[0]
   print ARGV[0]
end

db = PolySysDb.new(databaseFile.strip)
get '/test' do
   ARGV[0]
end
get '/systems/?' do
  @systemData = db.queryAll(PolySysDb::POLY_SYS_TABLE)
  haml :systems
end

get '/systems/*' do |name|
  @systemDetails = db.queryName(PolySysDb::POLY_SYS_TABLE, name) 
  if @systemDetails.count == 0
     "Page Not Found"
  else
     rp = ResultParser.new(@systemDetails[0])
     if @systemDetails[0]['longname'] == nil
        @pageTitle = @systemDetails[0]['name'].capitalize
     else
        @pageTitle = @systemDetails[0]['longname'].capitalize
     end
     @desc = @systemDetails[0]['desc']
     @familyDesc = @systemDetails[0]['familydesc']
     @family = @systemDetails[0]['familyname']
     @tableValues = rp.titleData(Array['tdeg','mvol','posdim','soln_c','soln_r'], Array['Tdeg', 'M vol', 'pos dim', 'Soln C', 'Soln r'])
     @fullRowValues =  rp.replaceBools(Array["posdim"], Array["has posDim"])
     @collapsibleBoxVals = rp.titleData(Array['eq_sym', 'eq_lee', 'ref'], Array['Eq Sym', 'Eq Lee', 'References'])
     haml :systemDetails
  end
end

get '/families/?' do
  @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
  @systemData = db.queryAll(PolySysDb::FAMILY_TABLE)
  haml :families
end

get '/families/*' do |name|
  family = db.queryName(PolySysDb::FAMILY_TABLE, name)
  if family.count == 0 
     "Page Not Found"
  else
     @systems = db.queryFamilyMembers(family[0]["id"])
     familyDetails = db.queryName(PolySysDb::FAMILY_TABLE, name) 
     @pageTitle = familyDetails[0]['name'].capitalize
     @desc = familyDetails[0]['desc']
     haml :familyDetails
  end
end

get '/partial' do 
   @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
   @systemData = db.queryAll(PolySysDb::FAMILY_TABLE)
   haml :testPartial1
end

