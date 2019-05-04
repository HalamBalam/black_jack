require_relative 'game_rules'

class Hand
  attr_reader :cards

  ACE_DIFFERENCE_VALUE = 10
  FULL_HAND_ERROR = "В руке не должно быть более #{GameRules::MAX_HAND_SIZE}-х карт".freeze

  def initialize
    @cards = []
  end

  def take_card(card)
    raise FULL_HAND_ERROR if full?

    cards << card
  end

  def value
    sum = @cards.inject(0) { |x, n| x + n.value }
    ace_correction(sum)
  end

  def clear
    cards.clear
  end

  def size
    cards.size
  end

  def full?
    size >= GameRules::MAX_HAND_SIZE
  end

  private

  def ace_correction(sum)
    cards.each { |card| sum -= ACE_DIFFERENCE_VALUE if card.ace? && sum > GameRules::BJ }
    sum
  end
end
