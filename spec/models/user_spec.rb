require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @password = "test123"
    @invalid_user = User.create(email: "testusername", password: @password)

    @valid_user = User.create(email: "test@username.com", password: @password)

    @duplicate_user = User.create(email: "test@username.com", password: @password)
    @duplicate_user_case_insensitive = User.create(email: "TEST@username.com", password: @password)
  end

  context 'User validations' do
    it 'User will not be created with invalid email address' do
      expect(@invalid_user).to_not be_valid
    end

    it 'User must have a valid email address' do
      expect(@valid_user).to be_valid
    end

    it 'User must have a unique email address' do
      expect(@duplicate_user).to_not be_valid
      expect(@duplicate_user.errors.messages[:email]).to include("Email has already been taken")
    end

    it 'User cannot sign up with the same case insensitive email address' do
      expect(@duplicate_user_case_insensitive).to_not be_valid
      expect(@duplicate_user_case_insensitive.errors.messages[:email]).to include("Email has already been taken")
    end

    it "User can be authenticated with the correct password w/ Bcrypt" do
      user_digest = @valid_user.password_digest
      bcrypt_digest = BCrypt::Password.new(user_digest)
      expect(bcrypt_digest).to eq(@password)
    end
  end
end
