# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, :type => :model do
  context 'with model validations' do
    let(:character_without_slug) do
      described_class.create(:name => 'Character Without Slug', :description => 'This is a character without a slug')
    end

    let(:character_without_name) do
      described_class.create(:slug => 'character_without_name', :description => 'This is a character without a name')
    end

    let(:character_without_description) do
      described_class.create(:name => 'Character Without Description', :slug => 'character_without_description')
    end

    it 'cannot be saved without a slug' do
      expect(character_without_slug).not_to be_valid
    end

    it 'cannot be saved without a name' do
      expect(character_without_name).not_to be_valid
    end

    it 'cannot be saved without a description' do
      expect(character_without_description).not_to be_valid
    end
  end

  context 'with model associations' do
    let(:character1) do
      described_class.create(:name => 'Character 1', :slug => 'character_1', :description => 'This is Character 1')
    end

    let(:character2) do
      described_class.create(:name => 'Character 2', :slug => 'character_2', :description => 'This is Character 2')
    end

    let(:easy_game) do
      Game.new(:difficulty => 'easy')
    end

    let(:quote1) do
      Quote.create(:content => 'Contents of Quote 1', :source => 'www.source1.com', :character_id => character1.id)
    end

    before do
      character1.quotes << quote1

      easy_game.characters = [character1, character2]
      easy_game.save
    end

    it 'has many quotes' do
      expect(character1.quotes.count).to eq(1)
    end

    it 'has and belongs to many games' do
      expect(character1.games).to include(easy_game)
      expect(easy_game.characters).to include(character1)
    end
  end
end
