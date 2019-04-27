class Player
  attr_accessor :name, :cash
  attr_reader :hand

  def initialize(name, cash)
    @name = name
    @cash = cash
    @hand = []
  end

  def take_card(deck)
    raise 'В руке не должно быть более 3-х карт' if hand.size >= 3

    hand << deck.give_random_card
  end

  def score
    result = 0
    sort_hand = hand.sort_by { |card| card.type == :A ? 1 : 0 }
    sort_hand.each { |card| result += card.value(result) }
    result
  end
end
