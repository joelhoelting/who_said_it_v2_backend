class User < ApplicationRecord
  has_secure_password
  has_many :games

  attribute :email_confirmed, :boolean, :default => false

  validates :email, 
    presence: true, 
    uniqueness: { case_sensitive: false, message: "Email has already been taken" }, 
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "User input is invalid" }, 
    on: :create

  before_create :downcase_fields

  def confirmation_token_expired?
    (Time.now.utc - self.email_confirmation_sent_at) > 1.hour
  end

  def set_email_confirmed
    self.update(:email_confirmed => true, :email_confirmation_token => nil, :email_confirmation_confirmed_at => DateTime.now)
  end

  def generate_token_and_send_instructions(token_type:)
    generate_token(:"#{token_type}_token")
    self[:"#{token_type}_sent_at"] = Time.now.utc
    save!
    UsersMailer.with(user: self).send(token_type).deliver
  end

  def generate_token(column)
    loop do
      token = friendly_token
      self[column] = token
      break token unless User.exists?(column => token)
    end
  end

  def parsed_user_data
    {
      :id => id,
      :email => email
    }
  end

  private
    def friendly_token(length = 48)
      SecureRandom.urlsafe_base64(length).to_s
    end

    def downcase_fields
      self.email.downcase!
    end
    
end
