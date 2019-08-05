class Quote < ApplicationRecord
  belongs_to :character
  validates_presence_of :content, :source, :character
end
