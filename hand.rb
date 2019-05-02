require_relative 'game_rules'

class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def take_card(card)
    raise "В руке не должно быть более #{GameRules::MAX_HAND_SIZE}-х карт" if cards.size >= GameRules::MAX_HAND_SIZE

    cards << card
  end

  def value
    result = 0
    sort_hand = cards.sort_by { |card| card.rank == 'A' ? 1 : 0 }
    sort_hand.each { |card| result += card.value(result) }
    result
  end

  def description(show_info = true)
    result = ''
    cards.each do |card|
      result += card.description if show_info
      result += '|*|' unless show_info
    end
    result
  end

  def clear
    cards.clear
  end

  def size
    cards.size
  end
end
