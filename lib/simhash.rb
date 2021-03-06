# encoding: utf-8

require 'active_support/core_ext/string/multibyte'
require 'unicode'

require 'string'
require 'integer'
require 'simhash/stopwords'

#begin
  require 'string_hashing'
#rescue LoadError
#end

module Simhash  
  DEFAULT_STRING_HASH_METHOD = String.public_instance_methods.include?("hash_vl") ? :hash_vl : :hash_vl_rb
 # DEFAULT_STRING_HASH_METHOD =   :hash_vl_rb
  PUNCTUATION_REGEXP = if RUBY_VERSION >= "1.9"
    /(\s|\d|[^\p{L}]|\302\240| *— *|[«»…\-–—]| )+/u
  else
    /(\s|\d|\W|\302\240| *— *|[«»…\-–—]| )+/u
  end
  
  
  def self.hash(tokens, options={})
    hashbits = options[:hashbits] || 64
    hashing_method = options[:hashing_method] || DEFAULT_STRING_HASH_METHOD
    language = options[:language] 
    #hashing_method = :hash_vl_rb    
        
    v = [0] * hashbits
    masks = v.dup
    masks.each_with_index {|e, i| masks[i] = (1 << i)}
    
    self.each_filtered_token(tokens, options) do |token|
      hashed_token = token.send(hashing_method, hashbits).to_i
#      puts hashed_token
      hashbits.times do |i|
        v[i] += (hashed_token & masks[i]).zero? ? -1 : +1
      end
    end
    #puts "v=#{v}"
   # puts "v size = #{v.size}"
    fingerprint = 0

    hashbits.times { |i| fingerprint += 1 << i if v[i] >= 0 }  
   # newstring="0b"
   # finger2=0
   # i=0
   # hashbits.times do 
   #   if v[i] >= 0
   #     newstring+="1"
   #     finger2+=1
   #   else
   #     newstring+="0"
   #   end        
   #   i+=1
   # end
   # puts "my new string=#{newstring}"
    
      fingerprint
   # fingerprint    
  #  newstring.to_i(10)
  end
  
  def self.each_filtered_token(tokens, options={})
    token_min_size = options[:token_min_size].to_i
    stop_sentenses = options[:stop_sentenses]
    language = options[:language]
    tokens.each do |token|
      # cutting punctuation (\302\240 is unbreakable space)
      token = token.gsub(PUNCTUATION_REGEXP, ' ') if !options[:preserve_punctuation]
      
      token = Unicode::downcase(token.strip)
      
      # cutting stop-words
      if language.nil?
        token = token.split(" ").reject{ |w| Stopwords::ALL.index(" #{w} ") != nil }.join(" ") if options[:stop_words]
      else
        language = options[:language][0..1].to_s.upcase 
        token = token.split(" ").reject{ |w| Stopwords.lng(language).index(" #{w} ") != nil }.join(" ") if options[:stop_words]
      end
    
      # cutting stop-sentenses
      next if stop_sentenses && stop_sentenses.include?(" #{token} ")
            
      next if token.size.zero? || token.mb_chars.size < token_min_size
      
      yield token      
    end
  end
  
  def self.filtered_tokens(tokens, options={})
    filtered_tokens = []
    self.each_filtered_token(tokens, options) { |token| filtered_tokens << token }
    filtered_tokens  
  end
  
  def self.hm
    @@string_hash_method
  end
end