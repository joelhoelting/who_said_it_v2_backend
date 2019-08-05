require 'rails_helper'

RSpec.describe Quote, type: :model do
  before do
    @character1 = Character.create(name: "Character 1", slug:"character_1", description: "This is Character 1")

    @valid_quote = Quote.create(content: "Description of valid quote", source: "www.source1.com", character_id: @character1.id)
    @quote_without_content = Quote.create(source: "www.quote_without_content.com", character_id: @character1.id)
    @quote_without_source = Quote.create(content: "Description of quote without source", character_id: @character1.id)
  end

  context 'Model validations' do
    it 'must belong to a character' do
      expect(@valid_quote.character).to eq(@character1)
    end

    it 'cannot be saved without content' do
      expect(@quote_without_content).to_not be_valid
    end

    it 'cannot be saved without a source' do
      expect(@quote_without_source).to_not be_valid
    end
  end

  context 'Model associations' do
    it 'belongs to a character' do
      expect(@valid_quote.character).to eq(@character1)
    end
  end
end
