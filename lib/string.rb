class String
  def simhash(options={})
    split_by = options.delete(:split_by) || " "
    Simhash.hash(self.split(split_by), options)
  end
  
  def hash_vl_rb(length)
    return 0 if self == ""

    x = self.bytes.first << 7
    m = 1000003
    mask = (1<<length) - 1
    self.each_byte{ |char| x = ((x * m) ^ char.to_i) & mask }

    x ^= self.bytes.count
    x = -2 if x == -1
    x
  end
  
  def custom_hash_vl_rb(length)
     return 0 if self == ""

     offset = length - 7
     x = bytes.first << offset
     m = 1000003
     mask = (1 << length) - 1
     each_byte { |char| x = ((x * m) ^ char.to_i) & mask }

     x ^= bytes.count
     x = -2 if x == -1
     x
   end
  
  
  def md5_hash(_)
     result = 0
     Digest::MD5.digest(self).bytes.each do |b|
       result <<= 8
       result += b
     end
     result
   end
   
   
   def sh1_hash(_)

     result = Digest::SHA2.hexdigest(self)
     Integer("0x#{result}").to_s         
   end
   
   
   
end