#This file is the command line interface for interacting with the database

require 'systemsDb'
require 'optparse'
require 'ostruct'

#SystemsCli handles parsing the command line flags
class SystemsCli
 
  :subcommand

   def self.helpString() 
       return "Usage:\n"  +
       " admin.rb add NAME LONGNAME TDEG MVOL\n" +
       " admin.rb delete NAME\n" +
       " admin.rb query [options]\n" +
       " admin.rb set NAME FIELD=VALUE\n" +
       " admin.rb addcolumn NAME TYPE\n"
       " admin.rb replace COLUMN REGEX REPLACEMENT\n"
       " admin.rb listfamilies\n"
   end

   def self.parse(args)

     options = OpenStruct.new
     options.name = ""
     options.all = false
     options.id = ""
     options.database = "systems.db"
    
      opts = OptionParser.new do |opts|
         opts.banner = SystemsCli.helpString()
         opts.separator ""
         opts.separator "Specific options:"
 
         opts.on("-d", "--database DATABASE_FILE
", "Specify database file") do |database|
            options.database = database
         end
        
         opts.on("-n", "--name NAME", "Select based on name") do |name|
            options.name = name || ''
         end
         opts.on("-i", "--id ID", "Select based on id") do |id|
            options.id = id
         end

         opts.on("-a", "--all", "Select all") do 
            options.all = true
         end

         opts.on("-f", "--family", "Operate on family") do 
            options.family = true
         end


      end
      opts.parse!(args)
      return options
   end
end

#parse the flags
#this removes the parsed flags from argv, leaving the subcommand and arguments
options = SystemsCli.parse(ARGV)
db = SystemsDb.new(options.database)

#default to operating on SYSTEM_TABLE 
if options.family
   table = SystemsDb::FAMILY_TABLE
else
   table = SystemsDb::SYSTEM_TABLE
end

case ARGV[0]
when "add"
   db.add(table, ARGV[1])
when "query"
   if options.all
      rows = db.queryAll(table)
   elsif options.name != ""
      rows = db.queryByName(table, options.name)
   end
   print "Systems\n"
   db.columns(table).each do |field|
      print field, " "
   end
   print "\n"
   rows.each do |row|
      db.columns(table).each do |field|
         print row[field], " "
      end
      print "\n"
   end

when "delete"
   name = ARGV[1]
   db.deleteByName(table, name)

when "replacetext"
   column = ARGV[1]
   regex = ARGV[2]
   replacement = ARGV[3]
   db.replace(table,column, regex, replacement)

when "addcolumn"
   name = ARGV[1]
   type = ARGV[2]
   db.addColumn(table, name,type)

when "set"
   name = ARGV[1]
   field,value = ARGV[2].split('=')
   #ensure that the field is in the table
   if db.columns(table).include?(field.strip) or field == 'familyname'
      db.set(table, name, field, value)
   else
      print "Unknown field: ", field, "\n\n"
      print "Valid fields: ", "\n"
      db.columns(table).each do |column|
         print column, "\n"
      end
   end

else
   print "Unknown subcommand\n"
   print SystemsCli.helpString()
end


