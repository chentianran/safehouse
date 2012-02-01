require 'sqlite3' 
class PolySysDb
   :db
   POLY_SYS_TABLE = "polySys" 
   FAMILY_TABLE = "families"  
   FILE_NAME = "polynomialSystems.db"
   
   def initialize()
      @db = SQLite3::Database.new(FILE_NAME)
      @db.results_as_hash = true
   end

   def buildNewTable()
     @db.execute("CREATE TABLE #{POLY_SYS_TABLE}(name text PRIMARY KEY, longname text, family text, tdeg integer, mvol text, family_id text)")
     @db.execute("CREATE TABLE #{FAMILY_TABLE}(id integer PRIMARY KEY AUTOINCREMENT, name text, desc text)")
   end
  

   def dropTable(table) 
     @db.execute("DROP TABLE #{table}")
     rescue SQLite3::SQLException
       return false
     return true
   end

   #db.execute("BEGIN TRANSACTION")
   def queryName(table, name)
	@db.transaction()
        rows = @db.execute("select * from #{table} where name = '#{name}'")
	@db.commit()
	return rows
   end   

   #dangerous method  
   def queryAll(table)
	@db.transaction()
        rows = @db.execute("select * from #{table}")
	@db.commit()
	return rows
   end   

   def add(table, name, *args)
      @db.transaction()
      if table == POLY_SYS_TABLE
         @db.execute("insert into #{POLY_SYS_TABLE} values('#{name}', '#{args.join("', '")}')") 
      elsif table == FAMILY_TABLE
         @db.execute("insert into #{FAMILY_TABLE} values(NULL, '#{name}', '#{args.join("', '")}')") 
      end
      @db.commit()
   end


   def set(table, name, field, value)
       @db.transaction()
       @db.execute("update #{table} set #{field} = '#{value}' where name = '#{name}'")
       @db.commit()
   end
  
   def deleteName(table, name)
      @db.transaction()
      @db.execute("delete from #{table} WHERE name='#{name}'")
      @db.commit()
   end 

   def addColumn(table, column, fieldtype)
      @db.transaction()
      @db.execute("alter table #{table} add column #{column} #{fieldtype}")
      @db.commit()
   end 

   def printAll()
      print "\nPolynomial Systems:\n"
      print "Name LongName tdeg mvol\n"
      rows = queryAll()
      rows.each do |name, longName, tdeg, mvol|
         print "#{name} #{longName} #{tdeg} #{mvol} \n"
      end
   end

   def fields(table)
       stmt = @db.prepare("select * from #{table}")
       return stmt.columns
   end
end


