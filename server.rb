require 'sinatra'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'resultParser'
require 'systemViewParser'

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
  @systemData = db.queryAll(SystemsDb::SYSTEM_TABLE)
  haml :systems
end

get '/systems/*' do |name|
  @systemDetails = db.queryByName(SystemsDb::SYSTEM_TABLE, name) 
  if @systemDetails.count == 0
     "Page Not Found"
  else
     rp =SystemViewParser.new(@systemDetails[0])
     @pageTitle = rp.getTitle()
     @tableValues = rp.getCornerTableData()
     @desc = rp.getDescriptions()
     @family = @systemDetails[0]['familyname']
     @fullRowValues =  rp.getBoolReplacements()
     @collapsibleBoxVals = rp.getCollapsibleBoxesData()
     haml :systemDetails
  end
end

get '/families/?' do
  @systemData = db.queryAll(SystemsDb::FAMILY_TABLE)
  haml :families
end

get '/families/*' do |name|
  family = db.queryByName(SystemsDb::FAMILY_TABLE, name)
  if family.count == 0 
     "Page Not Found"
  else
     @systems = db.querySystemsByFamId(family[0]["id"])
     familyDetails = db.queryByName(SystemsDb::FAMILY_TABLE, name) 
     @pageTitle = familyDetails[0]['name']
     @desc = familyDetails[0]['desc']
     haml :familyDetails
  end
end

