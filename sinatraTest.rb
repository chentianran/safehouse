require 'sinatra'
require 'sqlite3'
require 'haml'
#initialize database
db = SQLite3::Database.new( "polynomialSystems.db" )

get '/' do
  @text = ""
  haml :default
end

get '/system*' do
   @text = params[:name]
   haml :default
end

