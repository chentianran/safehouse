require 'sqlite3' 
class PolySysDb
   :db
   def initialize()
      @db = SQLite3::Database.new( "polynomialSystems.db")
   end

   def buildNewTable()
     @db.execute("CREATE TABLE polySys(Id integer PRIMARY KEY, Name text, LongName text, Tdeg integer, Mvol text)")
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
      @db.execute("insert into polySys values(NULL, '#{name}', '#{longName}', #{tdeg}, #{mvol})") 
      @db.commit()
   end
   
   def set(name, field, value)
       @db.transaction()
       @db.execute("update polySys set #{field} = '#{value}' where Name = '#{name}'");
       @db.commit()
   end

   def deleteID(id)
      @db.transaction()
      @db.execute("delete from polySys WHERE id=#{id}") 
      @db.commit()
   end
   
   def deleteName(name)
      @db.transaction()
      @db.execute("delete from polySys WHERE name=#{name}")
      @db.commit()
   end 

   def printAll()
      print "\nPolynomial Systems:\n"
      print "ID Name LongName tdeg mvol\n"
      rows = queryAll()
      rows.each do |id, name, longName, tdeg, mvol|
         print "#{id} #{name} #{longName} #{tdeg} #{mvol} \n"
      end
   end

   def fields 
      return ["name", "longName", "tdeg", "mvol"]
   end
end


