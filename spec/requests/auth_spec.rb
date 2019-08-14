require 'json'
require 'support/requests/auth_request_helpers'
require 'support/json_helper'

RSpec.configure do |c|
  c.include AuthRequestHelpers
  c.include JSONHelper
end

RSpec.describe "Authentication Requests", type: :request do
  before do
    @valid_user = User.create(email: "validuser@valid.com", password: "validuser123")
  end

  context "sign up user" do
    it "fails to sign up a user without email address" do
      sign_up_user(nil, "test123")
      
      expect(response.header['Content-Type']).to include('application/json')
      expect(response_body_to_json).to eq({"error"=>"Failed to create user"})
    end

    it "fails to sign up a user without password" do
      sign_up_user("test@test.com", nil)
      
      expect(response.header['Content-Type']).to include('application/json')
      expect(response_body_to_json).to eq({"error"=>"Failed to create user"})
    end

    it "succeeds when signing up a user with email/password" do
      sign_up_user("test@test.com", "test123")
      current_user = response_body_to_json["user"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(response.status).to eq 201
      expect(response_body_to_json).to_not eq({"error"=>"Failed to create user"})
      expect(User.find_by(email: "test@test.com").id).to eq(current_user["id"])
    end
  end

  context "sign in user" do
    it "fails to sign a user with wrong credentials" do
      sign_in_user("validuser@valid.com", "invaliduser123")
      expect(response.header['Content-Type']).to include('application/json')
      expect(response.status).to eq 401
      expect(response_body_to_json["error"]).to eq('Invalid credentials')
      end

    it "succeeds when signing in an existing user" do
      sign_in_user("validuser@valid.com", "validuser123")
      current_user = response_body_to_json["user"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(response.status).to eq 202
      expect(User.find_by(email: "validuser@valid.com").id).to eq(current_user["id"])      
    end
  end

  context "authorized resources require a JWT" do
    it "fails in accessing protected route (/profile) without token" do
      get_route_without_token("/api/v1/profile")
      expect(response.status).to eq 401
      expect(response_body_to_json["message"]).to eq "Please log in"
    end

    it "succeeds in accessing protected route (/profile) with token" do
      sign_in_user("validuser@valid.com", "validuser123")
      token = response_body_to_json["jwt"]
      get_route_with_token("/api/v1/profile", token)
      user_response = response_body_to_json["user"]
      expect(@valid_user.id).to eq(user_response["id"])
    end
  end
end

private

  def response_body_to_json
    JSON.parse(response.body)
  end