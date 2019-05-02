require_relative 'game_rules'

class Card
  attr_reader :suit, :rank

  SUITS = ['♠', '♥', '♦', '♣'].freeze
  RANKS = [*('2'..'10'), 'J', 'K', 'Q', 'A'].freeze
  HIGH_RANKS = %w[J K Q A].freeze

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def value(score)
    if rank == 'A'
      return score + GameRules::ACE_MAX_VALUE > GameRules::BJ ? GameRules::ACE_MIN_VALUE : GameRules::ACE_MAX_VALUE
    end
    return 10 if HIGH_RANKS.include?(rank)

    rank.to_i
  end

  def description
    "|#{rank}#{suit}|"
  end
end
