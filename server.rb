require 'sinatra'
require 'sqlite3'
require 'haml'
require 'polySysDb'

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
  @tableColumns = db.fields(PolySysDb::POLY_SYS_TABLE)
  @systemData = db.queryAll(PolySysDb::POLY_SYS_TABLE)
  haml :systems
end

get '/systems/*' do |name|
  @systemDetails = db.queryName(PolySysDb::POLY_SYS_TABLE, name) 
  if @systemDetails.count == 0
     "Page Not Found"
  else
     @tableColumns = db.fields(PolySysDb::POLY_SYS_TABLE)
     @fullRowValues =  replaceBools(@tableColumns[0])
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
     @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
     @systemDetails = db.queryName(PolySysDb::FAMILY_TABLE, name) 
     haml :familyDetails
  end
end

get '/partial' do 
   @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
   @systemData = db.queryAll(PolySysDb::FAMILY_TABLE)
   haml :testPartial1
end

