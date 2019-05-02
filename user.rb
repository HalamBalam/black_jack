class User < Player
  def description
    hand_description = hand.description
    score = hand.value

    result = "->#{name} (#{cash}$)"
    result += ": #{hand_description} СЧЕТ: #{score}" if hand.size > 0
    result
  end
end
