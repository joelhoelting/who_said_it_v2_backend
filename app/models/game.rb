class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :characters
  has_many :quotes, through: :characters

  serialize :ten_quote_ids, Array
  serialize :state, Array

  validates :difficulty, inclusion: { in: ['easy', 'medium', 'hard'] }
  # validates :validate_num_of_characters

  def game_quotes
    if ten_quote_ids.length == 10
      quotes.where(id: ten_quote_ids)
    else
      ten_quotes = quotes.order(Arel.sql('RANDOM()')).limit(10)
      update ten_quote_ids: ten_quotes.map(&:id)
      ten_quotes
    end
  end

  def add_characters_to_game(character_array)
    character_array.each do |character|
      characters << Character.find_by(character)
    end
  end

  private

    def validate_num_of_characters
      case difficulty
      when 'easy'
        binding.pry
      end
    end
end
