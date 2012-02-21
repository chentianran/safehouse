require 'sinatra'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'resultParser'
require 'systemViewParser'

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
databaseFile = "systems.db"
if ARGV.count > 0
   databaseFile = ARGV[0]
   print ARGV[0]
end

db = SystemsDb.new(databaseFile.strip)
get '/test' do
   ARGV[0]
end
get '/systems/?' do
  @systemData = db.queryAll(SystemsDb::POLY_SYS_TABLE)
  haml :systems
end

get '/systems/*' do |name|
  @systemDetails = db.queryName(SystemsDb::POLY_SYS_TABLE, name) 
  if @systemDetails.count == 0
     "Page Not Found"
  else
     rp =SystemViewParser.new(@systemDetails[0])
     @pageTitle = rp.getTitle().capitalize
     @tableValues = rp.getCornerTableData()
     @desc = rp.getDescriptions()
     @family = @systemDetails[0]['familyname']
     @fullRowValues =  rp.getBoolReplacements()
     @collapsibleBoxVals = rp.getCollapsibleBoxesData()
     haml :systemDetails
  end
end

get '/families/?' do
  @tableColumns = db.fields(SystemsDb::FAMILY_TABLE)
  @systemData = db.queryAll(SystemsDb::FAMILY_TABLE)
  haml :families
end

get '/families/*' do |name|
  family = db.queryName(SystemsDb::FAMILY_TABLE, name)
  if family.count == 0 
     "Page Not Found"
  else
     @systems = db.queryFamilyMembers(family[0]["id"])
     familyDetails = db.queryName(SystemsDb::FAMILY_TABLE, name) 
     @pageTitle = familyDetails[0]['name'].capitalize
     @desc = familyDetails[0]['desc']
     haml :familyDetails
  end
end

get '/partial' do 
   @tableColumns = db.fields(SystemsDb::FAMILY_TABLE)
   @systemData = db.queryAll(SystemsDb::FAMILY_TABLE)
   haml :testPartial1
end

