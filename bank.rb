class Bank
  attr_accessor :sum

  def initialize
    @sum = 0
  end

  def take_money(player, value)
    raise "У игрока \'#{player.name}\' недостаточно средств для ставки #{value.to_s}$" if value > player.cash
    @sum += value
    player.cash -= value
    puts "Игрок \'#{player.name}\' сделал ставку #{value.to_s}$"
  end

  def give_money(player)
    player.cash += sum
    puts "Игрок \'#{player.name}\' получил выигрыш #{sum.to_s}$"
    @sum = 0
  end
end
