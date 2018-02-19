require 'open-uri'

class PagesController < ApplicationController
  def new
    reset_session
  end


  def game
    generate_grid(10)
    @start_time = Time.now
  end


  def score
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @grid = params[:grid]
    @results = run_game(@attempt, @grid, @start_time, @end_time)

    if session[:score] == nil
      session[:score] = @results[:score]
    else
      session[:score] += @results[:score]
    end
    # session[:score] += @results[:score]
    if session[:plays] == nil
      session[:plays] = 1
    else
      session[:plays] += 1
    end
  end

  private

  def generate_grid(size)
    @grid = []
    size.times { @grid << ('A'..'Z').to_a.sample }
  end


  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    result[:message] = "well done"
    time_taken = (end_time.to_i - start_time.to_i) # .to_i
    result[:time] = time_taken / 1000
    score = (attempt.length ** attempt.length) - time_taken
    result[:score] = score
    return check_word(result, attempt, grid)
  end

  def check_word(result, attempt, grid)
    unless check_word_in_dictionary(attempt)["found"]
      result[:message] = "Dictionary says that #{attempt} is not an english word"
      result[:score] = 0
    end
    unless check_word_from_grid(attempt, grid)
      result[:message] = "not in the grid"
      result[:score] = 0
    end
    return result
  end

  def check_word_in_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_serialized = open(url).read
    return JSON.parse(dictionary_serialized)
  end

  def check_word_from_grid(word, grid)
    ## grid ARRAY of possible letters.
    temp_grid = grid # .join
    word = word.upcase
    word.split('').each do |letter|
      if temp_grid.include?(letter)
        temp_grid.sub!(letter, '')
      else
        return false
      end
    end
    return true
  end




end
