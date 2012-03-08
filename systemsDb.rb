require 'sqlite3' 

class SystemsDb
   :db
   SYSTEM_TABLE = "systems" 
   FAMILY_TABLE = "families"  

   
   SYSTEM_FIELDS =  <<-fieldStr
                        name text PRIMARY KEY, 
                        longname text, 
                        tdeg integer, 
                        mvol text, 
                        emvol text,
                        desc text, 
                        family_id text, 
                        eq_sym text, 
                        eq_lee text, 
                        eq_hps text,
                        ref text, 
                        soln_count_c integer, 
                        soln_count_r integer, 
                        
                        soln_c integer, 
                        soln_r integer, 

                        comp integer,
                        open integer,

                        posdim integer,
                        dim integer
                      fieldStr

   FAMILY_FIELDS = <<-fieldStr
                     id integer PRIMARY KEY AUTOINCREMENT, 
                     name text, 
                     desc text
                   fieldStr

   #opens the db residing in filename and initializes the class
   def initialize(filename)
      @db = SQLite3::Database.new(filename)
      @db.results_as_hash = true
   end

   #builds a new database with a table for systems of equations and a table for
   #families of systems of equations
   def buildNewDatabase()
      @db.execute("CREATE TABLE #{SYSTEM_TABLE}(#{SYSTEM_FIELDS})")
      @db.execute("CREATE TABLE #{FAMILY_TABLE}(#{FAMILY_FIELDS})")
   end
   
   def dropTable(table) 
      @db.execute("DROP TABLE #{table}")
      rescue SQLite3::SQLException
         return false
      return true
   end

   #queries for either a system or family by name 
   def queryByName(table, name)
      if(table == SYSTEM_TABLE)
         return querySystem("#{SYSTEM_TABLE}.name = '#{name}'")
      else
         return queryFamilyByName(name)
      end
   end
   
   #internal function that queries for a family by name
   def queryFamilyByName(name)
      @db.transaction()
      rows = @db.execute("SELECT * FROM #{FAMILY_TABLE} WHERE name = '#{name}'")
      @db.commit()
      return rows
   end   

   def endTrans()
      @db.commit()
   end
   #returns all systems that are in the family with id 'famId'
   def querySystemsByFamId(famId)
      return querySystem("#{SYSTEM_TABLE}.family_id = '#{famId}'")
   end   

   #returns all systeme for which condition is true
   def querySystem( condition )
      @db.transaction()
      #statement returns all of the columns in system, as well as the name and
      # description of the table associated with it
      rows = @db.execute( <<-SQL_STATEMENT)
         SELECT #{SYSTEM_TABLE}.* , 
                #{FAMILY_TABLE}.name AS familyname, 
                #{FAMILY_TABLE}.desc AS familydesc
         FROM #{SYSTEM_TABLE}
         LEFT JOIN #{FAMILY_TABLE} 
         ON  #{SYSTEM_TABLE}.family_id=#{FAMILY_TABLE}.id
         WHERE #{condition} 
      SQL_STATEMENT
      @db.commit()
      return rows
   end

   def queryFamilyById(famId)
      @db.transaction()
      rows = @db.execute("select * from #{FAMILY_TABLE} where family_id = '#{famId}'")
      @db.commit()
      return rows
   end   

   #returns all families or systems, depending on the table parameter
   def queryAll(table)
      if(table == SYSTEM_TABLE)
         return querySystem("1")
      else
         return queryAllFamily()
      end
   end

   #return all families in the family table
   def queryAllFamily()
      @db.transaction()
      rows = @db.execute("SELECT * FROM #{FAMILY_TABLE}")
      @db.commit()
      return rows
   end   
   
   #add a family or system to the database
   def add(table, name)
      @db.transaction()
      @db.execute("insert into #{table} (name) values ('#{name}')") 
      @db.commit()
   end 

   #add family or system, and initialize all arguments in args 
   def addAndInit(table, name, *args)
      @db.transaction()
      if table == SYSTEM_TABLE
         @db.execute("insert into #{SYSTEM_TABLE} values('#{name}', '#{args.join("', '")}')") 
      elsif table == FAMILY_TABLE
         @db.execute("insert into #{FAMILY_TABLE} values(NULL, '#{name}', '#{args.join("', '")}')") 
      end
      @db.commit()
   end

   #sets a field of a family or system
   #special field familyname in system is used to link a system to a family 
   # by specifying the name, rather than the family_id
   def set(table, name, field, value)
      if field == 'familyname'
         field = 'family_id'
         family = queryFamilyByName(value)
         if family.count == 0
            add(FAMILY_TABLE, value)
            family = queryFamilyByName(value)
         end
         value = family[0]['id']
      end
      @db.transaction()
      @db.execute("update #{table} set #{field} = '#{value}' where name = '#{name}'")
#      print "update #{table} set #{field} = '#{value}' where name = '#{name}'"
      @db.commit()
   end
  
   def deleteByName(table, name)
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

   #returns the names of the columns in a table
   def columns(table)
      stmt = @db.prepare("select * from #{table}")
      return stmt.columns
   end

end


