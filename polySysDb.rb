require 'sqlite3' 
class PolySysDb
   :db
   def initialize()
      @db = SQLite3::Database.new( "polynomialSystems.db")
      @db.results_as_hash = true
   end

   def buildNewTable()
     @db.execute("CREATE TABLE polySys(name text PRIMARY KEY, longname text, tdeg integer, mvol text)")
   end

   def dropTable() 
     @db.execute("DROP TABLE polySys")
     rescue SQLite3::SQLException
       return false
     return true
   end

   #db.execute("BEGIN TRANSACTION")
   def queryName(name)
	@db.transaction()
        rows = @db.execute("select * from polySys where Name = '#{name}'")
	@db.commit()
	return rows
   end   

   #dangerous method  
   def queryAll()
	@db.transaction()
        rows = @db.execute("select * from polySys")
	@db.commit()
	return rows
   end   

   def add(name, longName, tdeg, mvol)
      @db.transaction()
      @db.execute("insert into polySys values('#{name}', '#{longName}', #{tdeg}, #{mvol})") 
      @db.commit()
   end
   
   def set(name, field, value)
       @db.transaction()
       @db.execute("update polySys set #{field} = '#{value}' where Name = '#{name}'");
       @db.commit()
   end
   
   def deleteName(name)
      @db.transaction()
      @db.execute("delete from polySys WHERE name='#{name}'")
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

   def fields
       stmt = @db.prepare("select * from polySys")
       return stmt.columns
   end
end


