#!/usr/bin/ruby
programPath = ""
port = 8080
#IO.foreach("/home/jonckheere/safehouse/etc/safehouse") do |line|
IO.foreach("/etc/safehouse") do |line|
   if line.start_with?("PROGRAM_PATH") 
      programPath = line.split("=")[1].strip!
   elsif line.start_with?("PORT") 
      port = line.split("=")[1].strip!
   end
end

if programPath == ""
   print "Program path not specified"
end

Dir.chdir(programPath)


require 'rubygems'
require 'daemons'
require 'sqlite3'
require 'haml'
require 'server'

#reference;
#http://www.kalzumeus.com/2010/01/15/deploying-sinatra-on-ubuntu-in-which-i-employ-a-secretary/


Daemons.run_proc('server.rb') do
   exec "ruby #{programPath}/server.rb -env production -p #{port}"
end
