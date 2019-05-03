class Card
  attr_reader :suit, :rank

  ACE_VALUE = 11
  HIGH_RANK_VALUE = 10

  SUITS = ['♠', '♥', '♦', '♣'].freeze
  RANKS = [*('2'..'10'), 'J', 'K', 'Q', 'A'].freeze
  HIGH_RANKS = %w[J K Q A].freeze

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def ace?
    rank == 'A'
  end

  def value
    return ACE_VALUE if ace?
    return HIGH_RANK_VALUE if HIGH_RANKS.include?(rank)

    rank.to_i
  end

  def description
    "|#{rank}#{suit}|"
  end
end
