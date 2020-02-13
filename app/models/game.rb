class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :characters
  has_many :quotes, through: :characters

  serialize :ten_quote_ids, Array
  serialize :state, Array

  validates :difficulty, inclusion: { in: ['easy', 'medium', 'hard'], message: "Must have a difficulty level: easy, medium or hard" }
  validate :validate_num_of_characters

  def game_quotes
    if ten_quote_ids.length == 10
      quotes.where(id: ten_quote_ids)
    else
      ten_quotes = quotes.order(Arel.sql('RANDOM()')).limit(10)
      update ten_quote_ids: ten_quotes.map(&:id)
      ten_quotes
    end
  end

  def add_characters_by_id(character_ids)
    character_ids.sort.each { |id| characters << Character.find(id) }
  end

  private

  def validate_num_of_characters
    case difficulty
    when "easy"
      characters.length != 2 && errors.add(:difficulty, "Must have two characters")
    when "medium"
      characters.length != 3 && errors.add(:difficulty, "Must have three characters")
    when "hard"
      characters.length != 4 && errors.add(:difficulty, "Must have three characters")
    end
  end
end
