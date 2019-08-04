class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :quotes
end
