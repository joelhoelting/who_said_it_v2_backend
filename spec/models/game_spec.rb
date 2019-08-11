require 'rails_helper'

RSpec.describe Game, type: :model do
  before do
    @password = "test123"
    @user_with_games = User.create(email: "hasmanygames@email.com", password: @password)
    @user_without_games = User.create(email: "hasnogames@email.com", password: @password)

    @game_without_difficulty_level = Game.new

    @easy_game_invalid = Game.new(difficulty: "easy")
    @easy_game_invalid.add_characters_by_id([1,2,3])

    @easy_game = Game.new(difficulty: "easy")
    @easy_game.add_characters_by_id([1,2])

    @medium_game_invalid = Game.new(difficulty: "medium")
    @medium_game_invalid.add_characters_by_id([3,4,5,6])

    @medium_game = Game.new(difficulty: "medium")
    @medium_game.add_characters_by_id([3,4,5])

    @hard_game_invalid = Game.new(difficulty: "hard")
    @hard_game_invalid.add_characters_by_id([6,7,8,9,10])

    @hard_game = Game.new(difficulty: "hard")
    @hard_game.add_characters_by_id([6,7,8,9])

    @user_with_games.games = [@easy_game, @medium_game, @hard_game]
  end

  context 'model validations' do
    it 'cannot be saved without a difficulty level' do
      expect(@game_without_difficulty_level).to_not be_valid
    end

    it 'easy game should only have two characters' do
      expect(@easy_game_invalid.valid?).to eq(false)
      expect(@easy_game.characters.count).to eq(2)
    end

    it 'medium game should only have three characters' do
      expect(@medium_game_invalid.valid?).to eq(false)
      expect(@medium_game).to be_valid
      expect(@medium_game.characters.count).to eq(3)
    end

    it 'hard game should only have four characters' do
      expect(@hard_game_invalid.valid?).to eq(false)
      expect(@hard_game).to be_valid
      expect(@hard_game.characters.count).to eq(4)
    end
  end

  context 'model associations' do
    it 'can belong to a user' do
      expect(@easy_game.user).to eq(@user_with_games)
      expect(@medium_game.user).to eq(@user_with_games)
      expect(@hard_game.user).to eq(@user_with_games)
    end

    it 'does not have to belong to a user' do
      expect(@user_without_games).to be_valid
      expect(@user_without_games.games).to be_empty
    end
  end
end
