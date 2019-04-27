require_relative 'actions'

class UserPlayer < Player
  def description
    result = "->#{name} (#{cash}$)"
    result += ": #{hand_description} СЧЕТ: #{score}" unless hand.empty?
    result
  end

  def hand_description
    result = ''
    hand.each { |card| result += card.description }
    result
  end

  def make_move(deck)
    action = make_choice
    take_card(deck) if action == :add_card
    action
  end

  def make_choice
    actions = %i[skip add_card show_cards]
    actions.delete(:add_card) if hand.size >= 3

    Actions.choose(actions)
  end
end
