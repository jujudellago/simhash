# encoding: utf-8
require './test/helper'

class PerformanceTest < Test::Unit::TestCase
#  NBRS=[20,100,500]
    NBRS=[10,20,50,100]
  
  def test_hashing_speed
    puts "\n......................... test  256 hashbits and sh1_hash method ......................\n"
    
     NBRS.each do |n|
       time=measure_time do
         n.times do
           nbwords=rand(800..1800)
           words=Faker::Lorem.words(nbwords)
           text=words.join(" ")
           sih=text.simhash(:split_by => /\s+/, hashbits: 256,  hashing_method: :sh1_hash, :stop_words => true)
           #puts sih            
         end
       end
       puts "\nit took #{time} to calculate #{n} simhashes with 256 hashbits and sh1_hash method"
     end    
  end
  
  
  def test_hashing_speed_64
      puts "\n......................... test 64bit hashbits and ruby custom_hash_vl_rb ......................\n"
     NBRS.each do |n|
       time=measure_time do
         n.times do
           nbwords=rand(800..1800)
           words=Faker::Lorem.words(nbwords)
           text=words.join(" ")
           sih=text.simhash(:split_by => /\s+/, hashbits: 64,  hashing_method: :custom_hash_vl_rb, :stop_words => true) 
           #puts sih           
         end
       end
       puts "\nit took #{time} to calculate #{n} simhashes with 64bit hashbits and ruby custom_hash_vl_rb"
     end    
  end
  
  
  def test_hashing_speed_c
      puts "\n......................... test 64bit hashbits and hash_vl C method ......................\n"    
     NBRS.each do |n|
       time=measure_time do
         n.times do
           nbwords=rand(800..1800)
           words=Faker::Lorem.words(nbwords)
           text=words.join(" ")
           sih=text.simhash(:split_by => /\s+/, hashbits: 64,  hashing_method: :hash_vl, :stop_words => true) 
           #puts sih           
         end
       end
       puts "\nit took #{time} to calculate #{n} simhashes with 64 hashbits and hash_vl C method"
     end    
  end
  
  def test_hashing_speed_c_256
       puts "\n......................... test 256bit hashbits and hash_vl C method ......................\n"    
      NBRS.each do |n|
        time=measure_time do
          n.times do
            nbwords=rand(800..1800)
            words=Faker::Lorem.words(nbwords)
            text=words.join(" ")
            sih=text.simhash(:split_by => /\s+/, hashbits: 256,  hashing_method: :hash_vl, :stop_words => true) 
            #puts sih
          end
        end
        puts "\nit took #{time} to calculate #{n} simhashes with 256 hashbits and hash_vl C method"
      end    
   end
end