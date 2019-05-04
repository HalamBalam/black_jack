class Dealer < Player
  def description
    "#{name} (#{cash}$)"
  end

  def can_take_card?
    super && hand.value < GameRules::DEALER_SKIP_VALUE
  end
end
