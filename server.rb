require 'sinatra'
require 'sqlite3'
require 'haml'
#initialize database
db = SQLite3::Database.new( "polySys.db" )

get '/' do
  @text = ""
  haml :default
end

get '/buttonpress*' do
   @text = params[:name]
   haml :default
end

