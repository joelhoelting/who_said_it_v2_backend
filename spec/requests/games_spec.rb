require 'json'
require 'support/requests/game_request_helpers'
require 'support/json_helper'

RSpec.configure do |c|
  c.include GameRequestHelpers
  c.include JSONHelper
end

RSpec.describe "Games", type: :request do
  before do
    @easy_game_hash = {
      :difficulty => "easy", 
      :characters => [
        {:id => 2, :slug => "bill_hicks" }, 
        {:id => 5, :slug => "george_carlin" }
      ]
    }

    @medium_game_hash = {
      :difficulty => "medium", 
      :characters => [
        {:id => 2, :slug => "bill_hicks" }, 
        {:id => 5, :slug => "george_carlin" },
        {:id => 9, :slug => "mr_burns" }
      ]
    }

    @hard_game_hash = {
      :difficulty => "hard", 
      :characters => [
        {:id => 2, :slug => "bill_hicks" }, 
        {:id => 5, :slug => "george_carlin" },
        {:id => 9, :slug => "mr_burns" },
        {:id => 10, :slug => "mr_krabs" }
      ]
    }
  end

  context "unauthenticated: creates games" do
    it "succeeds in creating easy, medium and hard games" do
      games = [@easy_game_hash, @medium_game_hash, @hard_game_hash]
      validate_games(games)
    end
  end
end

private

  def validate_games(hash_array)
    hash_array.each do |hash|
      character_count = hash[:characters].count
      create_game(hash)

      expect(response.header['Content-Type']).to include('application/json')
      expect(response.status).to eq(201)

      game_response_id = response_body_to_json["id"]

      expect(game_response_id).to eq(Game.last.id)
      expect(Game.find(game_response_id).characters.count).to eq(character_count)
    end
  end