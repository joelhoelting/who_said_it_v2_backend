class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :characters
  has_many :quotes, through: :characters

  serialize :ten_quote_ids, Array
  serialize :state, Array

  validates :difficulty, inclusion: { in: ['easy', 'medium', 'hard'], message: "Must have a difficulty level: easy, medium or hard" }
  validate :validate_num_of_characters

  after_create :create_game_quotes

  def add_characters_by_id(character_ids)
    character_ids.sort.each { |id| self.characters << Character.find(id) }
  end

  def parsed_game_state
    self.state.map do |hash|
      {
        :evaluation => hash[:evaluation],
        :correct_character => Character.find(hash[:correct_character_id]),
        :selected_character => Character.find(hash[:selected_character_id]),
        :quote => Quote.find(hash[:quote_id])
      }
    end
  end

  # Avoid sending game quotes to client w/ answer (a.k.a character_id foreign key)
  def self_with_restricted_game_quotes
    {
      :id => self.id,
      :difficulty => self.difficulty,
      :game_quotes => self.game_quotes.map { |quote| {
        :id => quote.id,
        :content => quote.content,
        :source => quote.source,
      }}
    }
  end

  def create_game_quotes
    ten_quotes = self.quotes.order(Arel.sql('RANDOM()')).limit(10)
    self.update(:ten_quote_ids => ten_quotes.map(&:id))
  end

  def game_quotes
    self.ten_quote_ids.map { |id| Quote.find(id) }
  end

  def check_answer_and_update(params)
    @character = Character.find(params[:character_id])	
    @quote = Quote.find(params[:quote_id])
    quote_idx = params[:quote_idx]
    completed = quote_idx == 9

    expected_quote_idx = self.state.length
    expected_quote_id = self.game_quotes[expected_quote_idx].id
    
    # Ensure the correct quote idx and quote id are being posted from client  
    if quote_idx != expected_quote_idx || @quote.id != expected_quote_id 
      return false
    end

    evaluation = @quote.character.id == @character.id

		game_state_hash = {
			:correct_character_id => @quote.character.id,
			:selected_character_id => @character.id,
			:quote_id => @quote.id,
			:evaluation => evaluation
    }

    self.update(:state => self.state << game_state_hash, :completed => completed)

		return {
      :id => self.id,
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
