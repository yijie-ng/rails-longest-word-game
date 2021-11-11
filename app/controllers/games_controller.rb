require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U].freeze

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    input = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    input['found']
  end
end
