require 'systemsDb'

print "Are you sure you want to destroy the table? y/N: "
ans = STDIN.gets
ans.strip!
ans.downcase!
if ans == "y"
  db = SystemsDb.new(ARGV[0]) 
  db.dropTable(SystemsDb::SYSTEM_TABLE)
  db.dropTable(SystemsDb::FAMILY_TABLE)
end  
