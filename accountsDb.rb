require 'sqlite3' 

class AccountsDb 
   :db
   ACCOUNTS_TABLE = "accounts" 

  
   ACCOUNTS_FIELDS = <<-fieldStr
                     id integer PRIMARY KEY AUTOINCREMENT, 
                     openid text, 
                     name text,
                     admin int
                   fieldStr

   #opens the db residing in filename and initializes the class
   def initialize(filename)
      @db = SQLite3::Database.new(filename)
      @db.results_as_hash = true
   end

   #builds a new database with a table for systems of equations and a table for
   #families of systems of equations
   def buildNewDatabase()
      @db.execute("CREATE TABLE #{ACCOUNTS_TABLE}(#{ACCOUNTS_FIELDS})")
   end
   
   def dropTable(table= ACCOUNTS_TABLE ) 
      @db.execute("DROP TABLE #{table}")
      rescue SQLite3::SQLException
         return false
      return true
   end
   
   #internal function that queries for a family by name
   def queryByName(name )
      @db.transaction()
      rows = @db.execute("SELECT * FROM #{ACCOUNTS_TABLE} WHERE name = '#{name}'")
      @db.commit()
      return rows
   end   
 
   #internal function that queries for a family by name
   def queryByOpenId(openId)
      @db.transaction()
      rows = @db.execute("SELECT * FROM #{ACCOUNTS_TABLE} WHERE openid= '#{openId}'")
      @db.commit()
      return rows
   end   


   def endTrans()
      @db.commit()
   end
  
   #add a family or system to the database
   def add( name,table = ACCOUNTS_TABLE)
      @db.transaction()
      @db.execute("insert into #{table} (name) values ('#{name}')") 
      @db.commit()
   end 
  #sets a field of a family or system
   #special field familyname in system is used to link a system to a family 
   # by specifying the name, rather than the family_id
   def set( name, field, value, table =ACCOUNTS_TABLE )
      value = value.to_s().gsub(/'/,"''")

      @db.transaction()
      @db.execute("update #{table} set #{field} = '#{value}' where name = '#{name}'")
      @db.commit()
   end
 

   def deleteByName(name, table = ACCOUNTS_TABLE )
      @db.transaction()
      @db.execute("delete from #{table} WHERE name='#{name}'")
      @db.commit()
   end 

   def addColumn( column, fieldtype, table =  ACCOUNTS_TABLE )
      @db.transaction()
      @db.execute("alter table #{table} add column #{column} #{fieldtype}")
      @db.commit()
   end
   #returns the names of the columns in a table
   def columns(table = ACCOUNTS_TABLE)
      stmt = @db.prepare("select * from #{table}")
      return stmt.columns
   end


end


