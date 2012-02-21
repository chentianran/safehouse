require 'systemsDb'

db = SystemsDb.new('systems.db')

db.add(SystemsDb::FAMILY_TABLE, 'chen')
db.set(SystemsDb::FAMILY_TABLE, 'chen', 'desc', 'chen family desc')

db.add(SystemsDb::FAMILY_TABLE, 'newton')
db.set(SystemsDb::FAMILY_TABLE, 'newton','desc', 'newton table desc')

db.add(SystemsDb::FAMILY_TABLE, 'emptyFamily')

db.add(SystemsDb::SYSTEMS_TABLE, 'chen1')
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'longname', 'chenOne')
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'desc', '111111111111  11111111111111111 11111111111111 111111111111 1111111111 1  11111111111111 11111111111 11111111111 111111111111111 1111111111111111 111111111111111111 111111111111 11111111111111111111111 111111111111111111111 1 11111')
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'familyname', 'chen')
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'dim', 1)
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'tdeg', 2)
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'mvol', 3)
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'soln_count_c', 4)
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'soln_count_c', 5)

db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'posdim', '1')
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'open', '0')

db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'ref', "222222222222222222222222\n222222222 2222222222222222\n222222222222 222222222222222222\n2222222222")
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'eq_sym', "x=z\n z=y")
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'eq_hps', "x==z\n z==y ")
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'solns_c', "All Numbers")
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'solns_r', "All Reals")
db.set(SystemsDb::SYSTEMS_TABLE, 'chen1', 'comp', "1, 2, 3, \n 4")

db.add(SystemsDb::SYSTEMS_TABLE, 'emptySystem' )

#db.add(SystemsDb::SYSTEMS_TABLE, 'chen2', 'chenTwo', 1, 2, 1)
#db.add(SystemsDb::SYSTEMS_TABLE, 'chen3', 'chenThree', 1, 2, 1)
#db.add(SystemsDb::SYSTEMS_TABLE, 'newton1', 'newtonOne', 1, 2, 2)
