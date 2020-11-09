require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    # Find 5 vowels
    @letters = Array.new(5) { VOWELS.sample }
    # and 5 consonants
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # then shuffle and return the array
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    session[:score] = @word.length * 2 if @word
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
