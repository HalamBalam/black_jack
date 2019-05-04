require_relative 'player'
require_relative 'user'
require_relative 'dealer'
require_relative 'bank'
require_relative 'deck'
require_relative 'interface'
require_relative 'game_rules'

class Main
  attr_accessor :user, :dealer, :bank, :deck

  ACTION_NAMES = {
    skip: 'Пропустить',
    add_card: 'Добавить карту',
    show_cards: 'Открыть карты'
  }.freeze

  def run
    name = Interface.enter_user_name

    @user = User.new(name, GameRules::START_CASH)
    @dealer = Dealer.new('Дилер', GameRules::START_CASH)

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
    @bank.take_money(user, GameRules::BET)
    @bank.take_money(dealer, GameRules::BET)

    Interface.withdraw_message(user.name, GameRules::BET)
    Interface.withdraw_message(dealer.name, GameRules::BET)

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
      break if action == :show_cards || round_ended?

      dealer_move
      break if round_ended?

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

    [user, dealer].max_by { |player| player.hand.value }
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
    return false if user.cash < GameRules::BET || dealer.cash < GameRules::BET

    loop do
      choice = Interface.ask_for_next_game
      return true if %w[Y Д д].include?(choice)
      return false if %w[N Н н].include?(choice)
    end
  end

  def round_ended?
    [user, dealer].all? { |player| !player.can_take_card? }
  end

  def user_move
    action = choose_action
    user.hand.take_card(deck.give_random_card) if action == :add_card

    action_info(action, user)
    action
  end

  def choose_action
    actions = %i[skip add_card show_cards]
    actions.delete(:add_card) unless user.can_take_card?

    elements = []
    actions.each { |action| elements << ACTION_NAMES[action] }

    actions[Interface.choose_from_collection(elements)]
  end

  def dealer_move
    return :skip unless dealer.can_take_card?

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
