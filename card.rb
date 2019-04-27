class Card
  attr_reader :suit, :type

  PICTURE_TYPES = %i[J Q K A].freeze

  class << self
    def suits
      {
        spades: "\u2660",
        clubs: "\u2663",
        hearts: "\u2665",
        diamonds: "\u2666"
      }
    end

    def types
      result = []
      (2..10).each do |value|
        result << "_#{value}".to_sym
      end
      PICTURE_TYPES.each { |value| result << value }

      result
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

  def description
    type_name = type.to_s.sub('_', '')
    suit_name = self.class.suits[suit]
    "|#{type_name}#{suit_name}|"
  end
end
