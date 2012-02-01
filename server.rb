require 'sinatra'
require 'sqlite3'
require 'haml'
require 'polySysDb'

#initialize database
db = PolySysDb.new()
get '/systems/?' do
  @tableColumns = db.fields(PolySysDb::POLY_SYS_TABLE)
  @systemData = db.queryAll(PolySysDb::POLY_SYS_TABLE)
  haml :systems
end

get '/systems/*' do |name|
  @tableColumns = db.fields(PolySysDb::POLY_SYS_TABLE)
  @systemDetails = db.queryName(PolySysDb::POLY_SYS_TABLE, name) 
  haml :details
end

get '/families/?' do
  @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
  @systemData = db.queryAll(PolySysDb::FAMILY_TABLE)
  haml :families
end

get '/families/*' do |name|
  @tableColumns = db.fields(PolySysDb::FAMILY_TABLE)
  @systemDetails = db.queryName(PolySysDb::FAMILY_TABLE, name) 
  haml :details
end

