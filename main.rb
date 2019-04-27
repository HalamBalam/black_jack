require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Main

  START_CASH = 100
  BET = 10

  def run
    puts 'Введите имя игрока:'
    name = gets.chomp

    player1 = Player.new(name, START_CASH)
    player2 = Player.new('Дилер', START_CASH)

    @current_player = player1
    start_game(player1, player2)
  end

  def start_game(player1, player2)
    puts '**************НАЧАЛО ИГРЫ**************'

    bank = Bank.new
    bank.take_money(player1, BET)
    bank.take_money(player2, BET)

    deck = Deck.new

    2.times do
      player1.take_card(deck)
      player2.take_card(deck)
    end
  end

end

main = Main.new
main.run
