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
  DEALER_SKIP_VALUE = 17

  ACTION_NAMES = { skip: 'Пропустить', add_card: 'Добавить карту', show_cards: 'Открыть карты' }.freeze

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

    Interface.withdraw_message(user.name, BET)
    Interface.withdraw_message(dealer.name, BET)

    @deck = Deck.new

    2.times do
      user.hand.take_card(deck.give_random_card)
      dealer.hand.take_card(deck.give_random_card)
    end
  end

  def make_moves
    show_bank_info
    show_player_info(user)
    show_dealer_info

    loop do
      action = user_move
      break if action == :show_cards || max_cards_in_hands?

      dealer_move
      break if max_cards_in_hands?

      show_player_info(user)
      show_dealer_info
    end
  end

  def show_bank_info
    Interface.puts_empty_string
    Interface.show_description(bank)
  end

  def show_player_info(player)
    Interface.puts_empty_string
    Interface.show_description(player)
    Interface.show_cards(player.hand.cards)
    Interface.show_player_score(player.hand.value)
  end

  def show_dealer_info
    Interface.puts_empty_string
    Interface.show_description(dealer)
    Interface.show_card_mask(dealer.hand.size)
  end

  def end_game
    show_player_info(user)
    show_player_info(dealer)

    winner = determine_winner
    if winner.nil?
      game_result_draw
    else
      game_result_player_wins(winner)
    end

    user.hand.clear
    dealer.hand.clear

    Interface.show_description(user)
    Interface.show_description(dealer)
  end

  def determine_winner
    return if user.hand.value > GameRules::BJ && dealer.hand.value > GameRules::BJ
    return if user.hand.value == dealer.hand.value

    return dealer if user.hand.value > GameRules::BJ
    return user if dealer.hand.value > GameRules::BJ
    return user if user.hand.value > dealer.hand.value

    dealer
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

  def max_cards_in_hands?
    user.hand.full? && dealer.hand.full?
  end

  def user_move
    action = choose_action
    user.hand.take_card(deck.give_random_card) if action == :add_card

    action_info(action, user)
    action
  end

  def choose_action
    actions = %i[skip add_card show_cards]
    actions.delete(:add_card) if user.hand.full?

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
