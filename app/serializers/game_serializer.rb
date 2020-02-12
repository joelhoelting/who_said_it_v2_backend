class GameSerializer < ActiveModel::Serializer
  has_many :characters
  attributes :created_at, :id, :difficulty, :completed, :game_quotes, :state
end
