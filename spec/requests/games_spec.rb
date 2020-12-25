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
  before do
    @easy_game_hash = {
      :difficulty => 'easy',
      :characters => [
        { :id => 2, :slug => 'bill_hicks' },
        { :id => 5, :slug => 'george_carlin' }
      ]
    }

    @medium_game_hash = {
      :difficulty => 'medium',
      :characters => [
        { :id => 2, :slug => 'bill_hicks' },
        { :id => 5, :slug => 'george_carlin' },
        { :id => 9, :slug => 'mr_burns' }
      ]
    }

    @hard_game_hash = {
      :difficulty => 'hard',
      :characters => [
        { :id => 2, :slug => 'bill_hicks' },
        { :id => 5, :slug => 'george_carlin' },
        { :id => 9, :slug => 'mr_burns' },
        { :id => 10, :slug => 'mr_krabs' }
      ]
    }

    @game_hashes = [@easy_game_hash, @medium_game_hash, @hard_game_hash]

    @valid_user = User.create(:email => 'validuser@valid.com', :password => 'validuser123')
  end

  context 'unauthenticated: creates games' do
    it 'succeeds in creating easy, medium and hard games' do
      validate_games(@game_hashes)
    end
  end

  context 'authenticated: creates games' do
    it 'succeeds in logging in and creating a game associated with logged in user' do
      sign_in_user('validuser@valid.com', 'validuser123')
      token = response_body_to_json['jwt']

      validate_games_with_token(@game_hashes, token, @valid_user)
      expect(@valid_user.games.count).to eq(3)
    end
  end
end
