module GameRequestHelpers
  def create_game(hash)
    headers = { "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games", :params => hash.to_json, :headers => headers
  end
end

