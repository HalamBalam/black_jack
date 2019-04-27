class Card
  attr_reader :suit, :type

  PICTURE_TYPES = [:J, :Q, :K, :A]

  class << self 
    def suits
      [:diamonds, :spades, :clubs, :hearts]
    end

    def types
      result = []
      for value in 2..10 do
        result << "_#{value.to_s}".to_sym
      end
      PICTURE_TYPES.each { |value| result << value }

      return result
    end
  end

  def initialize(suit, type)
    @suit = suit
    @type = type
  end

  def value(score)
    if type == :A 
      return score + 11 > 21 ? 1 : 11
    end
    return 10 if PICTURE_TYPES.include?(type)
    type.to_s.sub('_', '').to_i
  end

end
