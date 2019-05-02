require_relative 'card'

class Deck
  attr_reader :cards

  EMPTY_DECK_ERROR = 'Колода пуста'.freeze

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each { |rank| cards << Card.new(suit, rank) }
    end
    @cards.shuffle!
  end

  def give_random_card
    raise EMPTY_DECK_ERROR if cards.empty?

    cards.pop
  end
end
