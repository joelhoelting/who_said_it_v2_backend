# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quote, :type => :model do
  let(:character1) do
    Character.create(:name => 'Character 1', :slug => 'character_1', :description => 'This is Character 1')
  end
  let(:valid_quote) do
    described_class.create(:content => 'Description of valid quote', :source => 'www.source1.com', :character_id => character1.id)
  end
  let(:quote_without_content) do
    described_class.create(:source => 'www.quote_without_content.com', :character_id => character1.id)
  end
  let(:quote_without_source) do
    described_class.create(:content => 'Description of quote without source', :character_id => character1.id)
  end

  context 'with model validations' do
    it 'must belong to a character' do
      expect(valid_quote.character).to eq(character1)
    end

    it 'cannot be saved without content' do
      expect(quote_without_content).not_to be_valid
    end

    it 'cannot be saved without a source' do
      expect(quote_without_source).not_to be_valid
    end
  end

  context 'with model associations' do
    it 'belongs to a character' do
      expect(valid_quote.character).to eq(character1)
    end
  end
end
