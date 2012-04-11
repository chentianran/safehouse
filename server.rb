programPath =""
IO.foreach("/home/jonckheere/safehouse/serverConfig") do |line|
   if line.start_with?("DATABASE_FILE") 
      databaseFile = line.split("=")[1].strip!
   elsif line.start_with?("PROGRAM_PATH") 
      programPath = line.split("=")[1].strip!
      print programPath
   end
end


require "rubygems"
require 'sinatra'
require 'sqlite3'
require 'haml'
require "#{programPath}/systemsDb"
print "#{programPath}/systemsDb"
require "#{programPath}/resultParser"
require "#{programPath}/systemViewParser"
require "#{programPath}/filter"
helpers do
   def partial( page, variables={} )
      haml page.to_sym, {layout=>false}, variables
   end

   def setPageNum( urlStr, page)
      if urlStr.sub!(/page=\d*/, "page=#{page}") == nil 
         if urlStr.include? '?' 
            return "#{urlStr}&page=#{page}"
         else
            return "#{urlStr}?page=#{page}"
         end
      else
         return urlStr
      end
   end

end

def divRndUp(dividend, divisor)
   return (dividend + divisor - 1) / divisor   
end

#initialize database

db = SystemsDb.new(databaseFile)

resultsPerPage = 30 

get '/test/?' do
   haml :test
end

get '/about/?' do
   "ABOUT"
end

get '/search/?' do
   if params[:page] != nil
      @page = params[:page].to_i
   else
      @page = 1
   end

   if params["s"] != nil   
      @systemData = db.search( params["s"], resultsPerPage,(@page - 1) * resultsPerPage)
 
      if @systemData == nil
         "No Results Found"
      end

      @pages = divRndUp(db.countResults(params["s"]), resultsPerPage) 
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
   @pages = divRndUp(db.countRows(SystemsDb::SYSTEM_TABLE), resultsPerPage)
   @systemData = db.queryAll(SystemsDb::SYSTEM_TABLE, resultsPerPage,(@page - 1) * resultsPerPage)
   @families = db.queryAll(SystemsDb::FAMILY_TABLE, resultsPerPage)
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
   @pages = divRndUp(db.countRows(SystemsDb::FAMILY_TABLE), resultsPerPage)

   @familyData= db.queryAll(SystemsDb::FAMILY_TABLE, resultsPerPage, (@page - 1) * resultsPerPage)

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

