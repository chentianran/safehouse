require 'systemsDb.rb'
db = SystemsDb.new("systems.db")
if ARGV[0] == nil
   print "Usage: readSym2.rb SYM2_FILE\n"
end

ARGV.each do |filename|
   begin
      systemName = filename.match(/(\w*)\.sym2$/ )[1]
      db.add(SystemsDb::SYSTEM_TABLE, systemName)
      f = File.new(filename)
      fileStr = f.read()
      f.close 
      fileStr.gsub!(/^#.*$/, "")
      fileStr.gsub!(/\{.*\}/m, "")
      fileStr.gsub!(/\*/, "")
      props = fileStr.split(/\n(?=^\w*=)/)
      props[1..-1].each do |prop|
         field,eq,value = prop.rpartition('=')
         db.set(SystemsDb::SYSTEM_TABLE, systemName, field, value)
      end
   rescue => e
      print "failed on #{filename}\n"
      print e
      db.endTrans()
   end      

end
 


