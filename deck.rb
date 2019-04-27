require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card.suits.each do |suit|
      Card.types.each { |type| cards << Card.new(suit, type) } 
    end
  end

  def give_random_card
    raise "Колода пуста" if cards.empty?
    cards.delete(cards[rand(cards.size)])
  end
end
