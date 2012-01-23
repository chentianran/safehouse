require 'polySysDb'
require 'optparse'
require 'ostruct'

class PolySysCli
   :subcommand 
   def self.parse(args)

     options = OpenStruct.new
     options.name = ""
     options.all = false
    
      opts = OptionParser.new do |opts|
         opts.banner = "Usage: admin.rb add NAME LONGNAME TDEG MVOL\n" +    
                       "       admin.rb delete ID\n" +
                       "       admin.rb query [options]\n"  
         opts.separator ""
         opts.separator "Specific options:"
         
         opts.on("-n", "--name NAME", "Query by name") do |name|
            options.name = name || ''
         end

         opts.on("-a", "--all", "Query all") do |name|
            options.all = true
         end

      end
      opts.parse!(args)
      options
   end
end

options = PolySysCli.parse(ARGV)
db = PolySysDb.new()
case ARGV[0]
when "add"
   #check to be sure there are enough arguments to add
   #the - 1 is to accound for the subcommand
   if ARGV.size - 1 != db.numSysFields
      print "Incorrect number of arguments to add\n"
      print "Usage: admin.rb add NAME LONGNAME TDEG MVOL\n"
   else
      db.add(ARGV[1], ARGV[2], ARGV[3], ARGV[4]);
   end
when "query"
   if options.all
      db.printAll()
      print "\n"
   end
when "delete"
   db.delete(ARGV.pop)
end


