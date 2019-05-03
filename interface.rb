module Interface
  class << self
    def enter_user_name
      puts 'Введите имя игрока:'
      gets.chomp
    end

    def show_start_message
      puts
      puts '**************НАЧАЛО ИГРЫ**************'
    end

    def show_end_message
      puts
      puts '**************КОНЕЦ ИГРЫ**************'
    end

    def puts_empty_string
      puts
    end

    def show_description(object)
      puts object.description
    end

    def game_status(player1_description, player2_description, bank_description = nil)
      puts
      puts bank_description unless bank_description.nil?
      puts player1_description
      puts player2_description
      puts
    end

    def show_result_draw
      puts
      puts 'РЕЗУЛЬТАТ ИГРЫ: НИЧЬЯ'
    end

    def show_result_player_wins(player_name)
      puts
      puts "РЕЗУЛЬТАТ ИГРЫ: ПОБЕДА ИГРОКА \'#{player_name}\'"
    end

    def ask_for_next_game
      puts
      puts 'Начать новую игру? (Y/N)'
      gets.chomp.upcase
    end

    def show_action_skip_info(player_name)
      puts "Игрок \'#{player_name}\' пропускает ход"
    end

    def show_action_add_card_info(player_name)
      puts "Игрок \'#{player_name}\' берёт одну карту"
    end

    def show_action_show_cards_info(player_name)
      puts "Игрок \'#{player_name}\' открывает карты"
    end

    def withdraw_message(player_name, value)
      puts "Игрок \'#{player_name}\' кладёт в банк #{value}$"
    end

    def debit_message(player_name, value)
      puts "Игрок \'#{player_name}\' забирает из банка #{value}$"
    end

    def choose_from_collection(elements)
      return if elements.empty?

      loop do
        show_collection(elements)

        index = gets.chomp.to_i - 1
        return index if index >= 0 && !elements[index].nil?
      end
    end

    def show_collection(elements)
      puts
      elements.each.with_index(1) do |element, index|
        puts "#{index}-\"#{element}\""
      end
    end

    def show_card_mask(count)
      mask = Array.new(count, '|*|').join(', ')
      puts mask
    end

    def show_cards(cards)
      cards_description = cards.map(&:description).join(', ')
      puts cards_description
    end

    def show_player_score(score)
      puts "СЧЁТ: #{score}"
    end
  end
end
