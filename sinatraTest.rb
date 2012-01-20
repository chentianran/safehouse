require 'sinatra'
require 'sqlite3'
require 'haml'
#initialize database
db = SQLite3::Database.new( "profs.db" )

get '/' do
   'Hello world!'
end
get '/query' do
  stream do |out|
  row = db.execute( "select * from professors" )
     row.each do |index,name,salary|
  	out << index.to_s + " " + name + " " +  salary.to_s + "<br />"
     end
 end 
end
get '/buttonpress*' do
   @text = params[:name]
   haml :default
#  name = params[:name]
#  template = File.read('views/default.haml')
#  haml_engine = Haml::Engine.new(template)
#  output = haml_engine.render(Object.new, :text => name)
end

get '/hamltest' do
  @text = ""
  haml :default
end
