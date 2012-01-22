require 'rubygems'
require 'thor'
require 'polySysDb'


class PolySysCli
   
   def self.parse(args)
    options = OpenStruct.new
     options.name = ""
     
   desc "query", "query the database"
   method_option :name, :aliases => "-n", :default => "", :desc => "query based on name"
   method_option :longName, :aliases => "-l", :default => "", :desc => "query based on long name"
   method_option :tdeg, :aliases => "-t", :default => "", :desc => "query based on tdeg"
   method_option :mvol, :aliases => "-m", :default => "", :desc => "query based on mvol"
   def query
    db = PolySysDb.new()
    results = db.queryName(options.name.strip)
    results.each do |id, name, longName, tdeg, mvol|
         print "#{id} #{name} #{longName} #{tdeg} #{mvol} \n"
    end 
   end
   
   desc "queryAll", "print everything in table"
   def queryAll
    db = PolySysDb.new()
    db.printAll()
  end


   desc "add NAME LONGNAME TDEG MVOL", "add a polynomial system to the database"
   def add(name, longName, tdeg, mvol)
    db = PolySysDb.new()
    db.add(name.strip, longName.strip,tdeg,mvol)
   end

   desc "remove ID", "remove a polynomial system based on id number"
   def remove(id)
    db = PolySysDb.new()
    db.remove(id)
   end
end

PolySysCli.start
