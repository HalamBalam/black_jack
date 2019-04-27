require_relative 'player'
require_relative 'user_player'
require_relative 'computer_player'
require_relative 'bank'
require_relative 'deck'
require_relative 'actions'

class Main
  attr_accessor :current_player, :dealer, :bank, :deck

  START_CASH = 100
  BET = 10

  def run
    puts 'Введите имя игрока:'
    name = gets.chomp

    @current_player = UserPlayer.new(name, START_CASH)
    @dealer = ComputerPlayer.new('Дилер', START_CASH)

    start_game
  end

  def start_game
    loop do
      puts
      puts '**************НАЧАЛО ИГРЫ**************'

      make_bets
      make_moves

      puts
      puts '**************КОНЕЦ ИГРЫ**************'

      end_game
      break unless next_game?
    end
  end

  def make_bets
    @bank = Bank.new
    @bank.take_money(current_player, BET)
    @bank.take_money(dealer, BET)

    @deck = Deck.new

    2.times do
      current_player.take_card(deck)
      dealer.take_card(deck)
    end
  end

  def make_moves
    show_status
    loop do
      action = current_player.make_move(deck)
      Actions.show_info(action, current_player)
      break if action == :show_cards || max_cards_in_hands?

      action = dealer.make_move(deck)
      Actions.show_info(action, dealer)
      break if max_cards_in_hands?

      show_status(false)
    end
  end

  def end_game
    dealer.show_info = true
    show_status

    current_player_delta = 21 - current_player.score
    dealer_delta = 21 - dealer.score

    if current_player_delta < 0 && dealer_delta < 0
      puts 'РЕЗУЛЬТАТ ИГРЫ: НЕТ ПОБЕДИТЕЛЯ'
      bank.take_players_bets
    elsif current_player.score == dealer.score
      puts 'РЕЗУЛЬТАТ ИГРЫ: НИЧЬЯ'
      bank.split_money(current_player, dealer)
    elsif current_player_delta < dealer_delta && current_player_delta > 0 || dealer_delta < 0
      puts "РЕЗУЛЬТАТ ИГРЫ: ПОБЕДА ИГРОКА \'#{current_player.name}\'"
      bank.give_money(current_player)
    else
      puts "РЕЗУЛЬТАТ ИГРЫ: ПОБЕДА ИГРОКА \'#{dealer.name}\'"
      bank.give_money(dealer)
    end

    current_player.hand.clear
    dealer.hand.clear

    show_status
    dealer.show_info = false
  end

  def next_game?
    return false if current_player.cash < BET || dealer.cash < BET

    loop do
      puts 'Начать новую игру? (Y/N)'
      choice = gets.chomp.upcase
      return true if %w[Y Д].include?(choice)
      return false if %w[N Н].include?(choice)
    end
  end

  def show_status(show_bank_info = true)
    puts
    puts bank.description if show_bank_info
    puts current_player.description
    puts dealer.description
    puts
  end

  def max_cards_in_hands?
    current_player.hand.size >= 3 && dealer.hand.size >= 3
  end
end

main = Main.new
main.run
