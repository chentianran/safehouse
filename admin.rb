require 'polySysDb'
require 'optparse'
require 'ostruct'

class PolySysCli
   :subcommand
   def self.parse(args)

     options = OpenStruct.new
     options.name = ""
     options.all = false
     options.id = ""
    
      opts = OptionParser.new do |opts|
         opts.banner = "Usage:\n"  +
                       " admin.rb add NAME LONGNAME TDEG MVOL\n" +
                       " admin.rb delete NAME\n" +
                       " admin.rb query [options]\n" +
                       " admin.rb set NAME FIELD=VALUE\n"
         opts.separator ""
         opts.separator "Specific options:"
         
         opts.on("-n", "--name NAME", "Select based on name") do |name|
            options.name = name || ''
         end
         opts.on("-i", "--id ID", "Select based on id") do |id|
            options.id = id
         end

         opts.on("-a", "--all", "Select all") do |name|
            options.all = true
         end
      end
      opts.parse!(args)
      return options
   end
end

options = PolySysCli.parse(ARGV)
db = PolySysDb.new()
case ARGV[0]
when "add"
   #check to be sure there are enough arguments to add
   #the ARGV.size - 1 is to account for the subcommand
   if ARGV.size - 1 != db.fields.count 
      print "Incorrect number of arguments to add\n"
      print "Usage: admin.rb add NAME LONGNAME TDEG MVOL\n"
   else
      db.add(ARGV[1], ARGV[2], ARGV[3], ARGV[4]);
   end
when "query"
   if options.all
      rows = db.queryAll()
   elsif options.name != ""
      rows = db.queryName(options.name)
   end
   print "Systems\n"
   db.fields.each do |field|
      print field, " "
   end
   print "\n"
   rows.each do |row|
      db.fields.each do |field|
         print row[field], " "
      end
      print "\n"
   end

when "delete"
   name = ARGV[1]
   db.deleteName(name)
when "set"
   name = ARGV[1]
   field,value = ARGV[2].split('=')
   if db.fields.include?(field.strip)
      db.set(name, field, value)
   else
      print "Unknown field: ", field, "\n\n"
      print "Valid fields: ", "\n"
      db.fields.each do |field|
        print field, "\n"
      end
   end
else
   print "Unknown subcommand\n"
end


