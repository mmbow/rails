module FunWithStrings

  def palindrome?
   self.downcase.gsub(/\W+/i,'') == self.downcase.gsub(/\W+/i,'').reverse
  end

  def count_words
     frequencies = Hash.new(0)
	 words = self.gsub(/[^a-z0-9\s]/i, "")
     words.downcase!
	 words = words.split(" ")
	 words.each { |key| frequencies[key]+=1}
     frequencies
  end


  def anagram_groups
	anagram = self.split(" ")
    anagram.group_by{|x| x.downcase.chars.sort}.values
  end
end

# make all the above functions available as instance methods on Strings:

class String
  include FunWithStrings
end
