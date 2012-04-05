require 'daemons'
require 'sqlite3'
require 'haml'
require 'systemsDb'
require 'resultParser'
require 'systemViewParser'
require 'filter'

require 'rubygems'
require 'daemons'

pwd = Dir.pwd
   Daemons.run_proc('server.rb', {:dir_mode => :normal, :dir => "/home/jonckheere/opts/"}) do
Dir.chdir(pwd)
exec "ruby server.rb"
end
