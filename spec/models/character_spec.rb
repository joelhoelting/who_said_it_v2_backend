require 'rails_helper'

RSpec.describe Character, type: :model do
  before do
    @character_without_slug = Character.create(name: "Character Without Slug", description: "This is a character without a slug")
    @character_without_name = Character.create(slug: "character_without_name", description: "This is a character without a name")
    @character_without_description = Character.create(name: "Character Without Description", slug: "character_without_description")

    @character1 = Character.create(name: "Character 1", slug:"character_1", description: "This is Character 1")
    @character2 = Character.create(name: "Character 2", slug:"character_2", description: "This is Character 2")
    @character3 = Character.create(name: "Character 3", slug:"character_3", description: "This is Character 3")

    @quote1 = Quote.create(content: "Contents of Quote 1", source: "www.source1.com", character_id: @character1.id)
    @quote2 = Quote.create(content: "Contents of Quote 2", source: "www.source2.com", character_id: @character2.id)

    @character1.quotes << @quote1
    @character2.quotes << @quote2

    @easy_game = Game.new(difficulty: "easy")
    @easy_game.characters = [@character1, @character2]
    @easy_game.save

    @medium_game = Game.new(difficulty: "medium")
    @medium_game.characters = [@character1, @character2, @character3]
    @medium_game.save
  end

  context 'Model validations' do
    it 'cannot be saved without a slug' do
      expect(@character_without_slug).to_not be_valid
    end

    it 'cannot be saved without a name' do
      expect(@character_without_name).to_not be_valid
    end

    it 'cannot be saved without a description' do
      expect(@character_without_description).to_not be_valid
    end
  end

  context 'Model associations' do
    it 'has many quotes' do
      expect(@character1.quotes.count).to eq(1)
    end

    it 'has and belongs to many games' do
      expect(@character1.games).to include(@easy_game)
      expect(@easy_game.characters).to include(@character1)
      expect(@medium_game.characters).to include(@character1)
    end
  end
end