require 'set'

class WordChainer
  
  def initialize dictionary_file_name = 'dictionary.txt'
    @dictionary = Set.new(File.readlines(dictionary_file_name).map(&:chomp))
    @all_seen_words = {}
  end
  
  def build_path start, target
    explore start, target
    word = target
    [].tap do |path|
      until path[0] == start
        path.unshift(word)
        #works backward from targer using each word's 'parent' 
        word = @all_seen_words[word]
      end
    end
  end
  
  def explore start, target
    @all_seen_words = {start => nil}
    current_words = [start]
    until current_words.empty?
      base_word = current_words.shift
      legal_steps(base_word).each do |word|
        @all_seen_words[word] = base_word
        return if word == target
        current_words <<  word
      end
    end
  end
  
  def legal_steps base_word
    adj_words = @dictionary.select do |possible_word|
      next if word_seen?(possible_word)
      next if possible_word.length != base_word.length
      words_adjacent?(base_word, possible_word)
    end
    adj_words 
  end
  
  def words_adjacent?(word1, word2)
    diffs = 0
    word1.each_char.with_index do |char, index|
      diffs += 1 unless word2[index] == char
    end
    diffs == 1
  end
  
  def word_seen?(word)
    @all_seen_words.include?(word)
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV
    word1 = ARGV[0]
    word2 = ARGV[1]
  else
    word1 = 'bear'
    word2 = 'wolf'
  end
  p WordChainer.new.build_path(word1, word2)
end