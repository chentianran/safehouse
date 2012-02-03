require 'polySysDb'

db = PolySysDb.new('polySys.db')

db.add(PolySysDb::FAMILY_TABLE, 'chen','chen table desc' )
db.add(PolySysDb::FAMILY_TABLE, 'newton', 'newton table desc')
db.add(PolySysDb::FAMILY_TABLE, 'empty', 'empty table desc')
db.add(PolySysDb::POLY_SYS_TABLE, 'chen1', 'chenOne', 1, 2, 1)
db.add(PolySysDb::POLY_SYS_TABLE, 'chen2', 'chenTwo', 1, 2, 1)
db.add(PolySysDb::POLY_SYS_TABLE, 'chen3', 'chenThree', 1, 2, 1)
db.add(PolySysDb::POLY_SYS_TABLE, 'newton1', 'newtonOne', 1, 2, 2)
