class QuoteSerializer < ActiveModel::Serializer
  attributes :id, :content, :source
  belongs_to :character
end
