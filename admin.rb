require 'polySysDb'
require 'optparse'
require 'ostruct'

class PolySysCli
 
  :subcommand

   def self.helpString() 
       return "Usage:\n"  +
       " admin.rb add NAME LONGNAME TDEG MVOL\n" +
       " admin.rb delete NAME\n" +
       " admin.rb query [options]\n" +
       " admin.rb set NAME FIELD=VALUE\n" +
       " admin.rb addcolumn NAME TYPE\n"
       " admin.rb listfamilies\n"
   end

   def self.parse(args)

     options = OpenStruct.new
     options.name = ""
     options.all = false
     options.id = ""
     options.database = "polysys.db"
    
      opts = OptionParser.new do |opts|
         opts.banner = PolySysCli.helpString()
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

options = PolySysCli.parse(ARGV)
db = PolySysDb.new(options.database)
if options.family
   table = PolySysDb::FAMILY_TABLE
else
   table =  PolySysDb::POLY_SYS_TABLE
end

case ARGV[0]
when "add"
   db.add(table, ARGV[1])
when "query"
   if options.all
      rows = db.queryAll(table)
   elsif options.name != ""
      rows = db.queryName(table, options.name)
   end
   print "Systems\n"
   db.fields(table).each do |field|
      print field, " "
   end
   print "\n"
   rows.each do |row|
      db.fields(table).each do |field|
         print row[field], " "
      end
      print "\n"
   end
when "queryfamily"
   rows = db.queryFamily(1)
   print "Systems\n"
   db.fields(table).each do |field|
      print field, " "
   end
   print "\n"
   rows.each do |row|
      db.fields(table).each do |field|
         print row[field], " "
      end
      print "\n"
   end


when "delete"
   name = ARGV[1]
   db.deleteName(table, name)

when "addcolumn"
   name = ARGV[1]
   type = ARGV[2]
   db.addColumn(table, name,type)

when "set"
   name = ARGV[1]
   field,value = ARGV[2].split('=')
   if db.fields(table).include?(field.strip) or field == 'familyname'
      db.set(table, name, field, value)
   else
      print "Unknown field: ", field, "\n\n"
      print "Valid fields: ", "\n"
      db.fields(table).each do |field|
         print field, "\n"
      end
   end

else
   print "Unknown subcommand\n"
   print PolySysCli.helpString()
end


