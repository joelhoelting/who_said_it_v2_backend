class GameSerializer < ActiveModel::Serializer
  has_many :characters
  attributes :id, :difficulty, :completed, :game_quotes, :state
end
