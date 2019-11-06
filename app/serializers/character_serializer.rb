class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug
end
