class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :characters
  has_many :quotes, through: :characters

  serialize :ten_quote_ids, Array
  serialize :state, Array

  validates :difficulty, inclusion: { in: ['easy', 'medium', 'hard'], message: "Must have a difficulty level: easy, medium or hard" }
  validate :validate_num_of_characters

  def add_characters_by_id(character_ids)
    character_ids.sort.each { |id| self.characters << Character.find(id) }
  end

  def game_quotes
    if ten_quote_ids.length == 10
      self.quotes.where(id: ten_quote_ids)
    else
      ten_quotes = self.quotes.order(Arel.sql('RANDOM()')).limit(10)
      self.update(:ten_quote_ids => ten_quotes.map(&:id))
      ten_quotes
    end
  end

  def check_answer_and_update(params)
    @character = Character.find(params[:character_id])	
		@quote = Quote.find(params[:quote_id])
    quote_idx = params[:quote_idx]
    completed = quote_idx == 9
    evaluation = @quote.character.id == @character.id

		game_state_hash = {
			:correct_character => @quote.character.id,
			:selected_character => @character.id,
			:quote => @quote.id,
			:evaluation => evaluation
    }

    self.update(:state => self.state << game_state_hash, :completed => completed)

		return { 
			:evaluation => evaluation,
			:correct_character => @quote.character.strip_character_params,
			:selected_character => @character.strip_character_params,
      :state => self.state,
      :completed => completed
		}
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
