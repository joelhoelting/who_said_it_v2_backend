class User < ApplicationRecord
  has_many :games

  validates :email, 
    presence: true, 
    uniqueness: { case_sensitive: false, message: "Email has already been taken" }, 
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "User input is invalid" }, 
    on: :create

  has_secure_password

  before_save :downcase_fields

  private

    def downcase_fields
      self.email.downcase!
    end
end
