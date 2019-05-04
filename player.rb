require_relative 'hand'

class Player
  attr_reader :hand, :cash, :name

  def initialize(name, cash)
    @name = name
    @cash = cash
    @hand = Hand.new
  end

  def withdraw(value)
    raise "У игрока \'#{name}\' недостаточно средств для списания #{value}$" if value > cash

    @cash -= value
  end

  def debit(value)
    @cash += value
  end

  def can_take_card?
    !hand.full?
  end
end
