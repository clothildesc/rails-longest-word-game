require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample
    end
    @letters
  end

  def included?(word, letters)
    word.chars.each do |letter|
      if letters.include(letter)
        letters.chars.delete_at(letters.index(letter))
      else
        false
      end
    true
  end

  def score
    @letters = params[:letters]
    if included?(params[:word], @letters) == false
      @message = "Sorry but #{params[:word].upcase} can't be build out of #{@letters.join(',')}"
    elsif included?(params[:word], @letters) == true
      url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
      word_serialized = URI.open(url).read
      @result = JSON.parse(word_serialized)
      if @result[:found] == false
        @message = "Sorry but #{params[:word].upcase} does not seem to be a valid English word..."
      else
        @message = "Congratulations! #{params[:word].upcase} is a valid English word!"
      end
    end
  end
end
