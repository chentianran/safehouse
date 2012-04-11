dir = File.dirname(File.expand_path(__FILE__))
print dir
print "\n"
Dir.chdir(dir)
require 'rubygems'
require 'daemons'
require 'sqlite3'
require 'haml'
require 'server'




#reference;
#http://www.kalzumeus.com/2010/01/15/deploying-sinatra-on-ubuntu-in-which-i-employ-a-secretary/

port = 8080

Daemons.run_proc('server.rb', {:dir_mode => :normal, :dir => "/home/jonckheere/opts/"}) do

Dir.chdir(dir)
exec "ruby /home/jonckheere/safehouse/server.rb -env production -p #{port}"
end
