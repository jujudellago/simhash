require 'rubygems'
require 'test/unit'
require 'unicode'

#require "lib/simhash"
#require "lib/string"
#require "lib/integer"

lib = File.expand_path("../../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "simhash"
require "string"
require "integer"
require "faker"
require "chronic_duration"
#require 'profile'

#begin
  require "string_hashing" 
#rescue LoadError
#  nil
#end


def measure_time(&block)
   t1 = Time.now
   yield
   dt = Time.now - t1 # difference between current time *now* and
                              # time that was current before execution of the block
                              # which (the difference) means time the block took to run
   return ChronicDuration.output(dt, :format => :short)                           

end