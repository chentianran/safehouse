require 'sinatra'
require 'sqlite3'
require 'haml'
require 'polySysDb'

#initialize database
db = PolySysDb.new()

def formatRows(rows)
      str = "" + 
      "\nPolynomial Systems:<br>"+
      "ID Name LongName tdeg mvol<br>"
      rows.each do |id, name, longName, tdeg, mvol|
         str += "#{id} #{name} #{longName} #{tdeg} #{mvol} #{name}<br>"
      end
   return str
end

get '/' do
  @text = ""
  haml :default
end

get '/system' do
   @text = db.queryAll()
   haml :default
end

