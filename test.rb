require 'systemsDb'

db = SystemsDb.new('systems.db')
res = db.queryName(SystemsDb::POLY_SYS_TABLE,'chen2')
print res.count ,"\n"
res[0].each_pair do |key, val|
  print key, ' ', val, "\n"
end

