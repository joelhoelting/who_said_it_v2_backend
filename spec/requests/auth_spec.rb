# require 'rails_helper'
require 'json'
require 'support/auth_helpers'

RSpec.configure do |c|
  c.include AuthHelpers
end

RSpec.describe "Authentication Requests", type: :request do
  before do
    @valid_user = User.create(email: "validuser@valid.com", password: "validuser123")
  end

  # context "sign up user" do
  #   it "fails to create a user without email" do
  #     headers = { "CONTENT_TYPE" => "application/json" }
  #     post "/api/v1/signup", :params => '{"password": "test123"}', :headers => headers
      
  #     expect(response.header['Content-Type']).to include('application/json')
  #     expect(JSON.parse(response.body)).to eq({"error"=>"Failed to create user"})
  #   end

  #   it "succeeds when signing up a user with email/password" do
  #     sign_up_user("test@test.com", "test123")
  #     current_user = response_body_to_json["user"]

  #     expect(response.header['Content-Type']).to include('application/json')
  #     expect(response.status).to eq 201
  #     expect(User.find_by(email: "test@test.com").id).to eq(current_user["id"])
  #   end
  # end

  # context "sign in user" do
  #   it "fails to sign a user with wrong credentials" do
  #     sign_in_user("validuser@valid.com", "invaliduser123")
  #     expect(response.header['Content-Type']).to include('application/json')
  #     expect(response.status).to eq 401
  #     expect(response_body_to_json["error"]).to eq('Invalid credentials')
  #     end

  #   it "succeeds when signing in an existing user" do
  #     sign_in_user("validuser@valid.com", "validuser123")
  #     current_user = response_body_to_json["user"]

  #     expect(response.header['Content-Type']).to include('application/json')
  #     expect(response.status).to eq 202
  #     expect(User.find_by(email: "validuser@valid.com").id).to eq(current_user["id"])      
  #   end
  # end

  context "ensure that authorized resources require a JWT" do
    it "fails in accessing protected route (/profile) without token" do
      get_route("/api/v1/profile")
      expect(response.status).to eq 401
      expect(response_body_to_json["message"]).to eq "Please log in"
    end

    it "succeeds in accessing protected route (/profile) with token" do
      sign_in_and_get_token("validuser@valid.com", "validuser123")
      token = response_body_to_json["jwt"]
      get_protected_route("/api/v1/profile", token)
      user_response = response_body_to_json["user"]
      expect(@valid_user.id).to eq(user_response["id"])
    end
  end
end

def response_body_to_json
  JSON.parse(response.body)
end