require 'sinatra'
require 'sqlite3'
require 'haml'
require 'polySysDb'

#initialize database
db = PolySysDb.new()
tableColumns = db.fields
get '/system/?' do
  @tableColumns = tableColumns
  @systemData = db.queryAll()
  haml :default
end

get '/system/*' do |name|
  @tableColumns = tableColumns
  @systemDetails = db.queryName(name) 
  haml :details
end

