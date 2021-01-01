# frozen_string_literal: true

require 'json'
require 'support/requests/auth_request_helpers'
require 'support/requests/game_request_helpers'
require 'support/general_helpers'

RSpec.configure do |c|
  c.include GameRequestHelpers
  c.include AuthRequestHelpers
  c.include GeneralHelpers
end

RSpec.describe 'Games', :type => :request do
  let(:easy_game_hash) do
    {
      :difficulty => 'easy',
      :characters => [2, 5]
    }
  end

  let(:medium_game_hash) do
    {
      :difficulty => 'medium',
      :characters => [2, 5, 9]
    }
  end

  let(:hard_game_hash) do
    {
      :difficulty => 'hard',
      :characters => [2, 5, 9, 10]
    }
  end

  let(:game_hashes) { [easy_game_hash, medium_game_hash, hard_game_hash] }
  let(:valid_email) { 'validuser@valid.com' }
  let(:valid_password) { 'validpassword123' }
  let(:user) { User.create(:email => valid_email, :password => valid_password) }

  context 'when user is unauthenticated: creates games' do
    it 'succeeds in creating easy, medium and hard games' do
      validate_games(game_hashes)
    end
  end

  context 'when user is authenticated: creates games' do
    it 'succeeds in logging in and creating a game associated with logged in user' do
      confirm_email(user.email_confirmation_token)
      sign_in_user(valid_email, valid_password)
      token = response_body_to_json['jwt']

      validate_games_with_token(game_hashes, token, user)
      expect(user.games.count).to eq(3)
    end
  end
end
