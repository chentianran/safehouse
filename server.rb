require 'sinatra'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'accountsDb'
require 'resultParser'
require 'systemViewParser'
require 'filter'
require 'fieldTitles'
gem 'ruby-openid', '>=2.1.2'
require 'openid'
require 'openid/store/filesystem'


enable :sessions


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

   #used for openid    
   def openid_consumer
      @openid_consumer ||= OpenID::Consumer.new(session,
       OpenID::Store::Filesystem.new("#{File.dirname(__FILE__)}/tmp/openid"))  
   end

   #used for openid
   def root_url
      request.url.match(/(^.*\/{2}[^\/]*)/)[1]
   end

end


#initialize database
databaseFile = "systems.db"
if ARGV.count > 0
   databaseFile = ARGV[0]
   print ARGV[0]
end

db = SystemsDb.new(databaseFile.strip)

databaseFile = "accounts.db"
if ARGV.count > 1
   databaseFile = ARGV[1]
   print ARGV[1]
end

accountsDb = AccountsDb.new("accounts.db")


#number of results to show on a page for systems and families results
resultsPerPage = 30

get '/add/system/?' do
   if session[:auth]
      haml :addSystem
   else
      redirect "/login"
   end
end

post '/add/system/?' do
   name = params[:name]
   params.delete(:name)
   begin
      db.add(SystemsDb::SYSTEM_TABLE, name)
   rescue
      db.endTrans()
   end
   params.each do |field, value|
      if value != ''
         db.set(SystemsDb::SYSTEM_TABLE,name, field, value)
      end
   end
   redirect "/systems/#{name}"
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

      @pages = (db.search(params["s"]).length + resultsPerPage-1) / resultsPerPage #round up
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
   @pages = (db.queryAll(SystemsDb::SYSTEM_TABLE).length + resultsPerPage-1) / resultsPerPage #round up
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
   if params[:firstletter] != nil
      firstLetter = params[:firstletter]
      @pages = (db.queryByFirstLetter(SystemsDb::FAMILY_TABLE, firstLetter).length + resultsPerPage-1) / resultsPerPage #round up
      @familyData = db.queryByFirstLetter(SystemsDb::FAMILY_TABLE, firstLetter, resultsPerPage,(@page - 1) * resultsPerPage)
   else
      @pages = (db.queryAll(SystemsDb::FAMILY_TABLE).length + resultsPerPage-1) / resultsPerPage #round up
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

get '/login' do
   haml :login
end

post '/login/openid' do
   openid = params[:openid_identifier]
   begin
      oidreq = openid_consumer.begin(openid)
   rescue OpenID::DiscoveryFailure => why
      "Sorry, we couldn't find your identifier #{openid}."
   else
      # You could request additional information here - see specs:
      # http://openid.net/specs/openid-simple-registration-extension-1_0.html
      oidreq.add_extension_arg('sreg','required','nickname')
      oidreq.add_extension_arg('sreg','optional','fullname, email')

      # Send request - first parameter: Trusted Site,
      # second parameter: redirect target
      redirect oidreq.redirect_url(root_url, root_url + "/login/openid/complete")
   end
end

get '/login/openid/complete' do
   oidresp = openid_consumer.complete(params, request.url)
   openid = oidresp.display_identifier

   case oidresp.status
      when OpenID::Consumer::FAILURE
      "Sorry, we could not authenticate you with this identifier #{openid}."

      when OpenID::Consumer::SETUP_NEEDED
      "Immediate request failed - Setup Needed"

      when OpenID::Consumer::CANCEL
      "Login cancelled."

      when OpenID::Consumer::SUCCESS
      # Access additional informations:
      # puts params['openid.sreg.nickname']
      
      accountInfo = accountsDb.queryByOpenId(params['openid.identity'])
      if accountInfo[0]['admin'] == 1
         session[:auth] = true
         redirect "/add/system"
      else
         session[:auth] = false
         "You do not have admin access"
      end

 #     str = ""
 #     params.each do |row, val|
 #        str += "#{row}= #{val}<BR>"
 #     end
   end
end


