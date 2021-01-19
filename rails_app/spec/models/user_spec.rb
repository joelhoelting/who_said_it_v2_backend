# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, :type => :model do
  password = 'password123'

  let!(:invalid_user) { described_class.new(:email => 'testemail', :password => password) }
  let!(:valid_user) { described_class.create(:email => 'test@email.com', :password => password) }
  let!(:duplicate_user) { described_class.new(:email => 'test@email.com', :password => password) }
  let!(:duplicate_user_case_insensitive) { described_class.new(:email => 'TEST@email.com', :password => password) }
  let!(:user_with_many_games) { described_class.create(:email => 'hasmanygames@email.com', :password => password) }

  let(:easy_game) { Game.new(:difficulty => 'easy') }
  let(:medium_game) { Game.new(:difficulty => 'medium') }
  let(:hard_game) { Game.new(:difficulty => 'hard') }

  before do
    easy_game.add_characters_by_id([1, 2])
    easy_game.save

    medium_game.add_characters_by_id([3, 4, 5])
    medium_game.save

    hard_game.add_characters_by_id([6, 7, 8])
    hard_game.save

    [easy_game, medium_game, hard_game].each { |game| user_with_many_games.games << game }
  end

  context 'with model validations' do
    it 'cannot be created with invalid email address' do
      expect(invalid_user).not_to be_valid
    end

    it 'must have a valid email address' do
      expect(valid_user).to be_valid
    end

    it 'must have a unique email address' do
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors.messages[:email]).to include('Email has already been taken')
    end

    it 'cannot sign up with the same case insensitive email address' do
      expect(duplicate_user_case_insensitive).not_to be_valid
      expect(duplicate_user_case_insensitive.errors.messages[:email]).to include('Email has already been taken')
    end

    it 'can be authenticated with the correct password w/ Bcrypt' do
      user_digest = valid_user.password_digest
      bcrypt_digest = BCrypt::Password.new(user_digest)
      expect(bcrypt_digest).to eq(password)
    end
  end

  context 'with model associations' do
    it 'has many games' do
      expect(user_with_many_games.games.length).to eq(3)
    end
  end
end
