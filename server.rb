require 'sinatra'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'resultParser'
require 'systemViewParser'
require 'filter'

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

resultsPerPage = 5 

get '/search/?' do
   if params["s"] != nil   
      @systemData = db.search( params["s"]) 
      if @systemData == nil
         "No Results Found"
      end
      @pages = (@systemData.length + resultsPerPage) / resultsPerPage # round up 
      @page = 1
      @families = db.queryAll(SystemsDb::FAMILY_TABLE)
      haml :systems
   else
      "No Search Term"
   end
   
end

get '/systems/?' do
   if params[:page] != nil
      @page = params[:page].to_i
   else
      @page = 1
   end
   @pages = (db.queryAll(SystemsDb::SYSTEM_TABLE).length + resultsPerPage) / resultsPerPage #round up
  @systemData = db.queryAll(SystemsDb::SYSTEM_TABLE, resultsPerPage,(@page - 1) * resultsPerPage)
  @families = db.queryAll(SystemsDb::FAMILY_TABLE,resultsPerPage)
  haml :systems
end

get '/systems/*' do |name|
  @systemDetails = db.queryByName(SystemsDb::SYSTEM_TABLE, name) 
  filterExpAndSub(@systemDetails)
  if @systemDetails.count == 0
     "Page Not Found"
  else
     if @systemDetails[0]['ref'] == nil
         @systemDetails[0]['ref'] = @systemDetails[0]['familyref']   
     end
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
   if params[:page] != nil
      @page = params[:page].to_i
   else
      @page = 1
   end
   @pages = (db.queryAll(SystemsDb::FAMILY_TABLE).length + resultsPerPage) / resultsPerPage #round up

   @familyData= db.queryAll(SystemsDb::FAMILY_TABLE, resultsPerPage,(@page - 1) * resultsPerPage)

  haml :families
end

get '/families/*' do |name|
  family = db.queryByName(SystemsDb::FAMILY_TABLE, name)
  if family.count == 0 
     "Page Not Found"
  else
     @systemData = db.querySystemsByFamId(family[0]["id"])
     familyDetails = db.queryByName(SystemsDb::FAMILY_TABLE, name) 
     @pageTitle = familyDetails[0]['name']
     @desc = familyDetails[0]['desc']
     haml :familyDetails
  end
end

