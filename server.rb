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

get '/system' do
  @tableColumns = db.fields
  @systemData = db.queryAll()
  haml :default
end

