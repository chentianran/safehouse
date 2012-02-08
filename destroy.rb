require 'polySysDb'

print "Are you sure you want to destroy the table? y/N: "
ans = STDIN.gets
ans.strip!
ans.downcase!
if ans == "y"
  db = PolySysDb.new(ARGV[0]) 
  db.dropTable(PolySysDb::POLY_SYS_TABLE)
  db.dropTable(PolySysDb::FAMILY_TABLE)
end  
