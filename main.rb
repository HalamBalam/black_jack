require_relative 'player'
require_relative 'user'
require_relative 'dealer'
require_relative 'bank'
require_relative 'deck'
require_relative 'interface'
require_relative 'game_rules'

class Main
  attr_accessor :user, :dealer, :bank, :deck

  START_CASH = 100
  BET = 10

  ACTION_NAMES = { skip: 'Пропустить', add_card: 'Добавить карту', show_cards: 'Открыть карты' }.freeze

  DEALER_SKIP_VALUE = 17

  def run
    name = Interface.enter_user_name

    @user = User.new(name, START_CASH)
    @dealer = Dealer.new('Дилер', START_CASH)

    start_game
  end

  def start_game
    loop do
      Interface.show_start_message

      make_bets
      make_moves

      Interface.show_end_message

      end_game
      break unless next_game?
    end
  end

  def make_bets
    @bank = Bank.new
    @bank.take_money(user, BET)
    @bank.take_money(dealer, BET)

    @deck = Deck.new

    2.times do
      user.hand.take_card(deck.give_random_card)
      dealer.hand.take_card(deck.give_random_card)
    end
  end

  def make_moves
    game_status

    loop do
      action = user_move
      break if action == :show_cards || max_cards_in_hands?

      dealer_move
      break if max_cards_in_hands?

      game_status(false)
    end
  end

  def end_game
    dealer.show_info = true
    game_status

    user_delta = GameRules::BJ - user.hand.value
    dealer_delta = GameRules::BJ - dealer.hand.value

    if user_delta < 0 && dealer_delta < 0
      game_result_no_winner
    elsif user_delta == dealer_delta
      game_result_draw
    elsif user_delta < dealer_delta && user_delta > 0 || dealer_delta < 0
      game_result_player_wins(user)
    else
      game_result_player_wins(dealer)
    end

    user.hand.clear
    dealer.hand.clear

    game_status
    dealer.show_info = false
  end

  def game_result_no_winner
    Interface.show_result_no_winner
    bank.take_players_bets
  end

  def game_result_draw
    Interface.show_result_draw
    bank.split_money(user, dealer)
  end

  def game_result_player_wins(player)
    Interface.show_result_player_wins(player.name)
    bank.give_money(player)
  end

  def next_game?
    return false if user.cash < BET || dealer.cash < BET

    loop do
      choice = Interface.ask_for_next_game
      return true if %w[Y Д д].include?(choice)
      return false if %w[N Н н].include?(choice)
    end
  end

  def game_status(show_bank_info = true)
    bank_description = bank.description if show_bank_info
    Interface.game_status(user.description, dealer.description, bank_description)
  end

  def max_cards_in_hands?
    user.hand.size >= GameRules::MAX_HAND_SIZE && dealer.hand.size >= GameRules::MAX_HAND_SIZE
  end

  def user_move
    action = choose_action
    user.hand.take_card(deck.give_random_card) if action == :add_card

    action_info(action, user)
    action
  end

  def choose_action
    actions = %i[skip add_card show_cards]
    actions.delete(:add_card) if user.hand.size >= GameRules::MAX_HAND_SIZE

    elements = []
    actions.each { |action| elements << ACTION_NAMES[action] }

    actions[Interface.choose_from_collection(elements)]
  end

  def dealer_move
    return :skip if dealer.hand.value >= DEALER_SKIP_VALUE

    action = :add_card
    dealer.hand.take_card(deck.give_random_card)

    action_info(action, dealer)
    action
  end

  def action_info(action, player)
    Interface.send("show_action_#{action}_info".to_sym, player.name)
  end
end

main = Main.new
main.run
