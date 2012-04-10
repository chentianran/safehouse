require 'daemons'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'resultParser'
require 'systemViewParser'
require 'filter'

require 'rubygems'
require 'daemons'
#reference;
#http://www.kalzumeus.com/2010/01/15/deploying-sinatra-on-ubuntu-in-which-i-employ-a-secretary/

port = 8080

pwd = Dir.pwd
   Daemons.run_proc('server.rb', {:dir_mode => :normal, :dir => "/home/jonckheere/opts/"}) do
Dir.chdir(pwd)
exec "ruby server.rb -env production -p #{port}"
end
