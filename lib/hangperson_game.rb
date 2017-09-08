class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @curr_state = :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(nguess)
    if nguess.nil? or nguess.empty? or nguess =~ /[^A-Za-z]+/
      raise ArgumentError
    end

    nguess.downcase!

    if not @guesses.include? nguess and not @wrong_guesses.include? nguess
      if @word.include? nguess
        @guesses << nguess
        if not word_with_guesses.include? '-'
          @curr_state = :win
        end
      else
        @wrong_guesses << nguess
        if @wrong_guesses.length >= 7
          @curr_state = :lose
        end
      end
      return true
    end
    return false
  end

  def check_win_or_lose
    return @curr_state
  end

  def word_with_guesses
    # puts "-----------------------------------------------"
    # puts @word.gsub(/[^#{@guesses}]/, '-')
    # puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    if @guesses.empty?
      return @word.gsub(/./, '-')
    end
    return @word.gsub(/[^#{@guesses}]/, '-')
  end


end
