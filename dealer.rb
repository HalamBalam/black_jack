class Dealer < Player
  attr_accessor :show_info

  def initialize(name, cash)
    super(name, cash)
    @show_info = false
  end

  def description
    result = "#{name} (#{cash}$)"
    hand_description = hand.description(show_info)
    score = hand.value

    if hand.size > 0
      result += ": #{hand_description}"
      result += " СЧЕТ: #{score}" if show_info
    end
    result
  end

  def short_description
    "#{name} (#{cash}$)"
  end
end
