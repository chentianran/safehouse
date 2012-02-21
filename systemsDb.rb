require 'sqlite3' 

class SystemsDb
   :db
   SYSTEMS_TABLE = "systems" 
   FAMILY_TABLE = "families"  
   
   SYSTEMS_FIELDS =  <<-fieldStr
                        name text PRIMARY KEY, 
                        longname text, 
                        tdeg integer, 
                        mvol text, 
                        desc text, 
                        family_id text, 
                        eq_sym text, 
                        eq_lee text, 
                        ref text, 
                        soln_c integer, 
                        soln_r integer, 
                        posdim integer
                      fieldStr

   FAMILY_FIELDS = <<-fieldStr
                     id integer PRIMARY KEY AUTOINCREMENT, 
                     name text, 
                     desc text
                   fieldStr

  def initialize(filename)
      @db = SQLite3::Database.new(filename)
      @db.results_as_hash = true
   end

   def buildNewTable()
     @db.execute("CREATE TABLE #{SYSTEMS_TABLE}(#{SYSTEMS_FIELDS})")
     @db.execute("CREATE TABLE #{FAMILY_TABLE}(#{FAMILY_FIELDS})")
   end

   def dropTable(table) 
     @db.execute("DROP TABLE #{table}")
     rescue SQLite3::SQLException
       return false
     return true
   end

  def queryName(table, name)
     if(table == SYSTEMS_TABLE)
        queryNameSystem(name)
     else
        queryNameFamily(name)
     end
  end

   def queryNameFamily(name)
   @db.transaction()
        rows = @db.execute("SELECT * FROM #{FAMILY_TABLE} WHERE name = '#{name}'")
   @db.commit()
   return rows
   end   

   #db.execute("BEGIN TRANSACTION")
   def queryNameSystem( name)
<<<<<<< HEAD:polySysDb.rb
   @db.transaction()
        rows = @db.execute( <<-SQL_STATEMENT)
   SELECT #{SYSTEMS_TABLE}.* , #{FAMILY_TABLE}.name AS familyname, #{FAMILY_TABLE}.desc AS familydesc
   FROM #{SYSTEMS_TABLE}
   LEFT JOIN #{FAMILY_TABLE} 
   ON  #{SYSTEMS_TABLE}.family_id=#{FAMILY_TABLE}.id
        WHERE #{SYSTEMS_TABLE}.name = '#{name}'
=======
	@db.transaction()
        rows = @db.execute( <<SQL_STATEMENT)
	SELECT #{SYSTEMS_TABLE}.* , #{FAMILY_TABLE}.name AS familyname, #{FAMILY_TABLE}.desc AS familydesc
	FROM #{SYSTEMS_TABLE}
	LEFT JOIN #{FAMILY_TABLE} 
	ON  #{SYSTEMS_TABLE}.family_id=#{FAMILY_TABLE}.id
        WHERE #{SYSTEMS_TABLE}.name = '#{name}'
>>>>>>> fb88325a1234de22f6cb170e36ab392ff3e7ad9e:systemsDb.rb
SQL_STATEMENT
   @db.commit()
   return rows
   end   

   def queryFamilyMembers(famID)
      return querySystem("#{SYSTEMS_TABLE}.family_id = '#{famID}'")
   end   

   #returns all systeme for which condition is true
   def querySystem( condition )
      @db.transaction()
      #statement returns all of the columns in system, as well as the name and
      # description of the table associated with it
      rows = @db.execute( <<-SQL_STATEMENT)
         SELECT #{SYSTEMS_TABLE}.* , 
                #{FAMILY_TABLE}.name AS familyname, 
                #{FAMILY_TABLE}.desc AS familydesc
         FROM #{SYSTEMS_TABLE}
         LEFT JOIN #{FAMILY_TABLE} 
         ON  #{SYSTEMS_TABLE}.family_id=#{FAMILY_TABLE}.id
              WHERE #{condition} 
      SQL_STATEMENT
      @db.commit()
      return rows
   end

   def queryFamily(famID)
   @db.transaction()
        rows = @db.execute("select * from #{FAMILY_TABLE} where family_id = '#{famID}'")
   @db.commit()
   return rows
   end   

  def queryAll(table)
     if(table == SYSTEMS_TABLE)
        queryAllSystem()
     else
        queryAllFamily()
     end
  end

   def queryAllFamily()
   @db.transaction()
        rows = @db.execute("SELECT * FROM #{FAMILY_TABLE}")
   @db.commit()
   return rows
   end   


   #dangerous method  
   def queryAllSystem()
   @db.transaction()
        rows = @db.execute( <<-SQL_STATEMENT)
   SELECT #{SYSTEMS_TABLE}.* , #{FAMILY_TABLE}.name AS familyname, #{FAMILY_TABLE}.desc AS familydesc
   FROM #{SYSTEMS_TABLE}
   LEFT JOIN #{FAMILY_TABLE} 
   ON #{SYSTEMS_TABLE}.family_id=#{FAMILY_TABLE}.id
   SQL_STATEMENT
   @db.commit()

   return rows
   end   

   def add(table, name)
      @db.transaction()
      @db.execute("insert into #{table} (name) values ('#{name}')") 
      @db.commit()
   end 

   def addAndInit(table, name, *args)
      @db.transaction()
      if table == SYSTEMS_TABLE
         @db.execute("insert into #{SYSTEMS_TABLE} values('#{name}', '#{args.join("', '")}')") 
      elsif table == FAMILY_TABLE
         @db.execute("insert into #{FAMILY_TABLE} values(NULL, '#{name}', '#{args.join("', '")}')") 
      end
      @db.commit()
   end


   def set(table, name, field, value)
       if field == 'familyname'
          field = 'family_id'
          family = queryNameFamily(value)
          if family.count == 0
             add(FAMILY_TABLE, value)
             family = queryNameFamily(value)
          end
          value = family[0]['id']
       end
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


