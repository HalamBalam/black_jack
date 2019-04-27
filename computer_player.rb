class ComputerPlayer < Player
  attr_accessor :show_info

  def initialize(name, cash)
    super(name, cash)
    @show_info = false
  end

  def description
    result = "#{name} (#{cash}$)"

    unless hand.empty?
      result += ": #{hand_description}"
      result += " СЧЕТ: #{score}" if show_info
    end
    result
  end

  def short_description
    "#{name} (#{cash}$)"
  end

  def hand_description
    result = ''
    hand.each do |card|
      result += card.description if show_info
      result += '|*|' unless show_info
    end
    result
  end

  def make_move(deck)
    return :skip if score >= 17

    take_card(deck)
    :add_card
  end
end
