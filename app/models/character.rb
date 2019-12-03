class Character < ApplicationRecord
  has_and_belongs_to_many :games
  has_many :quotes
  validates_presence_of :slug, :name, :description

  def strip_character_params
    self.slice(:id, :slug, :name, :description)
  end
end
