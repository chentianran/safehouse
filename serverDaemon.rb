require 'rubygems'
require 'daemons'
require 'sqlite3'
require 'haml'
#reference;
#http://www.kalzumeus.com/2010/01/15/deploying-sinatra-on-ubuntu-in-which-i-employ-a-secretary/

port = 80

pwd = Dir.pwd
   Daemons.run_proc('server.rb', {:dir_mode => :normal, :dir => "/home/jonckheere/opts/"}) do
Dir.chdir(pwd)
exec "ruby /home/jonckheere/safehouse/server.rb -env production -p #{port}"
end
