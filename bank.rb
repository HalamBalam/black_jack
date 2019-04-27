class Bank
  attr_accessor :sum

  def initialize
    @sum = 0
  end

  def take_money(player, value)
    raise "У игрока \'#{player.name}\' недостаточно средств для ставки #{value}$" if value > player.cash

    @sum += value
    player.cash -= value
    puts "Игрок \'#{player.name}\' сделал ставку #{value}$"
  end

  def give_money(player)
    player.cash += sum
    puts "Игрок \'#{player.name}\' забирает из банка #{sum}$"
    @sum = 0
  end

  def split_money(player1, player2)
    player1.cash += sum * 0.5
    player2.cash += sum * 0.5
    puts 'Банк поделён между игроками'
    @sum = 0
  end

  def take_players_bets
    puts 'Банк забирает ставки игроков'
    @sum = 0
  end

  def description
    "Банк игры: #{sum}$"
  end
end
