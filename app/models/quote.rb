class Quote < ApplicationRecord
  belongs_to :character
  validates :character, presence: true
end
