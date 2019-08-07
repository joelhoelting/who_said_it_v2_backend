# require 'rails_helper'

RSpec.describe "Authentication Requests", type: :request do
  context "POST /api/v1/signup" do
    it "fails to create a user without email" do
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/signup", :params => '{"password": "test123"}', :headers => headers
      
      expect(response.header['Content-Type']).to include('application/json')
      expect(JSON.parse(response.body)).to eq({"error"=>"Failed to create user"})
    end

    it "succeeds to create a user with correct credentials" do
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/signup", :params => '{"email": "test@test.com", "password": "password123"}', :headers => headers
      expect(response.header['Content-Type']).to include('application/json')
      
      current_user = response_body["user"]

      expect(response.status).to eq 201
      expect(User.find_by(email: "test@test.com").id).to eq(current_user["id"])
      expect(current_user["email"]).to eq("test@test.com")
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
