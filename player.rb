require_relative 'interface'
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

    Interface.withdraw_message(name, value)
    @cash -= value
  end

  def debit(value)
    Interface.debit_message(name, value)
    @cash += value
  end
end
