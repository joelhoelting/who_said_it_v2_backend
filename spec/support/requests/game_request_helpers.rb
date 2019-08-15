module GameRequestHelpers
  def create_game(hash)
    headers = { :CONTENT_TYPE => "application/json" }
    post "/api/v1/games", :params => hash.to_json, :headers => headers
  end

  def create_game_with_token(hash, token)
    headers = { :CONTENT_TYPE => "application/json", :HTTP_AUTHORIZATION => "Bearer #{token}" }
    post "/api/v1/games", :params => hash.to_json, :headers => headers
  end

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

    def validate_games_with_token(hash_array, token, user)
      hash_array.each do |hash|
        character_count = hash[:characters].count
        create_game_with_token(hash, token)
  
        expect(response.header['Content-Type']).to include('application/json')
        expect(response.status).to eq(201)
  
        game_response_id = response_body_to_json["id"]
  
        expect(game_response_id).to eq(Game.last.id)
        expect(Game.find(game_response_id).characters.count).to eq(character_count)
        expect(Game.find(game_response_id).user).to eq(user)
      end
    end
  end
end

