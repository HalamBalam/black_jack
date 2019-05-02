require_relative 'interface'

class Bank
  attr_accessor :sum

  def initialize
    @sum = 0
  end

  def take_money(player, value)
    player.withdraw(value)
    @sum += value
  end

  def give_money(player)
    player.debit(sum)
    @sum = 0
  end

  def split_money(player1, player2)
    player1.debit(sum * 0.5)
    player2.debit(sum * 0.5)
    @sum = 0
  end

  def take_players_bets
    Interface.bank_takes_money_message
    @sum = 0
  end

  def description
    "Банк игры: #{sum}$"
  end
end
