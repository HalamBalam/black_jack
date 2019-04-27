module Actions
  class << self
    def choose(elements)
      return if elements.empty?

      loop do
        show_collection(elements)

        index = gets.chomp.to_i - 1
        return elements[index] if index >= 0 && !elements[index].nil?
      end
    end

    def show_collection(elements)
      elements.each.with_index(1) do |element, index|
        puts "#{index}-\"#{action_name(element)}\""
      end
    end

    def action_name(action)
      action_names = { skip: 'Пропустить', add_card: 'Добавить карту', show_cards: 'Открыть карты' }
      action_names[action]
    end

    def show_info(action, player)
      case action
      when :skip then puts "Игрок \'#{player.name}\' пропускает ход"
      when :add_card then puts "Игрок \'#{player.name}\' берёт одну карту"
      when :show_cards then puts "Игрок \'#{player.name}\' открывает карты"
      end
    end
  end
end
