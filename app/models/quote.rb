class Quote < ApplicationRecord
  belongs_to :character
  validates_presence_of :content, :source, :character

  def as_json(options={})
    { :content => content, # just use the attribute when no helper is needed
      :id => id
    }
  end
end
