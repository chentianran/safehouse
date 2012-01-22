require 'rubygems'
require 'polySysDb'
require 'optparse'
require 'ostruct'

class PolySysCli
   
   def self.parse(args)
    options = OpenStruct.new
     options.name = ""
    
      opts = OptionParser.new do |opts|
         opts.banner = "Usage: admin.rb add NAME LONGNAME TDEG MVOL\n" +    
                       "       admin.rb delete ID\n" +
                       "       admin.rb query [options]\n"  
         opts.separator ""
         opts.separator "Specific options:"
         
         opts.on("-n", "--name NAME", "Query by name") do |name|
            options.name = name || ''
         end
      end
   end
end

options = PolySysCli.parse(ARGV)
