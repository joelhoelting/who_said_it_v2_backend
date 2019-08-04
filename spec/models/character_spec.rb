require 'rails_helper'

RSpec.describe Character, type: :model do
  before do
    @character1 = Character.create(name: "Character 1", slug:"character_1", description: "This is Character 1")
    @character2 = Character.create(name: "Character 2", slug:"character_2", description: "This is Character 2")

    @quote1 = Quote.create(content: "Contents of Quote 1", source: "www.source1.com", character_id: @character1.id)
    @quote2 = Quote.create(content: "Contents of Quote 2", source: "www.source2.com", character_id: @character2.id)

    @character1.quotes = [@quote1, @quote2]
  end

  context 'Model associations' do
    it 'Character has many quotes' do
      expect(@character1.quotes.count).to eq(2)
    end
  end
end