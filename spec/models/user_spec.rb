require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    @password = "test123"
    @invalid_user = User.new(:email => "testemail", :password => @password)

    @valid_user = User.create(:email => "test@email.com", :password => @password)

    @duplicate_user = User.new(:email => "test@email.com", :password => @password)
    @duplicate_user_case_insensitive = User.new(:email => "TEST@email.com", :password => @password)

    # Associations between users and games
    @user_with_many_games = User.create(:email => "hasmanygames@email.com", :password => @password)  
    
    @easy_game = Game.new(:difficulty => "easy")
    @easy_game.add_characters_by_id([1,2])
    @easy_game.save

    @medium_game = Game.new(:difficulty => "medium")
    @medium_game.add_characters_by_id([3,4,5])
    @medium_game.save

    @hard_game = Game.new(:difficulty => "hard")
    @hard_game.add_characters_by_id([6,7,8])
    @hard_game.save

    [@easy_game, @medium_game, @hard_game].each { |game| @user_with_many_games.games << game }
  end

  context 'model validations' do
    it 'cannot be created with invalid email address' do
      expect(@invalid_user).to_not be_valid
    end

    it 'must have a valid email address' do
      expect(@valid_user).to be_valid
    end

    it 'must have a unique email address' do
      expect(@duplicate_user).to_not be_valid
      expect(@duplicate_user.errors.messages[:email]).to include("Email has already been taken")
    end

    it 'cannot sign up with the same case insensitive email address' do
      expect(@duplicate_user_case_insensitive).to_not be_valid
      expect(@duplicate_user_case_insensitive.errors.messages[:email]).to include("Email has already been taken")
    end

    it "can be authenticated with the correct password w/ Bcrypt" do
      user_digest = @valid_user.password_digest
      bcrypt_digest = BCrypt::Password.new(user_digest)
      expect(bcrypt_digest).to eq(@password)
    end
  end

  context 'model associations' do
    it 'has many games' do
      expect(@user_with_many_games.games.length).to eq(3)
    end
  end
end
