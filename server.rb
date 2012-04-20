dir = File.dirname(File.expand_path(__FILE__))
Dir.chdir(dir)

require "systemsDb"
require "resultParser"
require "systemViewParser"
require "filter"

require "rubygems"
require 'sinatra'
require 'sqlite3'
require 'haml'

#require 'fieldTitles'
gem 'ruby-openid', '>=2.1.2'
require 'openid'
require 'openid/store/filesystem'


enable :sessions

configFile ="/home/jonckheere/safehouse/etc/safehouse" 
#configFile = "/etc/safehouse"
databaseFile = "systems.db"
IO.foreach(configFile) do |line|
   if line.start_with?("DATABASE_FILE") 
      databaseFile = line.split("=")[1].strip!
   end
end

helpers do
   #render a partial haml page
   def partial( page, variables={} )
      haml page.to_sym, {layout=>false}, variables
   end

   #change the page parameter in a url
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

db = SystemsDb.new(databaseFile)

#number of results to show on a page for systems and families results
resultsPerPage = 30

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
     rp = SystemViewParser.new(@systemDetails[0])
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
   if params[:firstletter] != nil
      firstLetter = params[:firstletter]
      @pages = divRndUp(db.queryByFirstLetter(SystemsDb::FAMILY_TABLE, firstLetter).length,  resultsPerPage) #round up
      @familyData = db.queryByFirstLetter(SystemsDb::FAMILY_TABLE, firstLetter, resultsPerPage,(@page - 1) * resultsPerPage)
   else
      @pages = divRndUp(db.queryAll(SystemsDb::FAMILY_TABLE).length, resultsPerPage) #round up
      @familyData= db.queryAll(SystemsDb::FAMILY_TABLE, resultsPerPage,(@page - 1) * resultsPerPage)
   end
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

