require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card.suits.each_key do |suit|
      Card.types.each { |type| cards << Card.new(suit, type) }
    end
    @cards.shuffle!
  end

  def give_random_card
    raise 'Колода пуста' if cards.empty?

    cards.pop
  end
end
