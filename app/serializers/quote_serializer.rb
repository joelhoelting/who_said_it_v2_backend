class QuoteSerializer < ActiveModel::Serializer
  # belongs_to :character
  attributes :id, :content, :source
end
