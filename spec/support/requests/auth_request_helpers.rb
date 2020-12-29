# frozen_string_literal: true

module AuthRequestHelpers
  def sign_up_user(email, password)
    user_hash = tap_user_hash(email, password)
    post '/api/v1/sign_up', :params => { :user => user_hash }, :headers => headers, :as => :json
  end

  def sign_in_user(email, password)
    user_hash = tap_user_hash(email, password)
    post '/api/v1/sign_in', :params => { :user => user_hash }, :headers => headers, :as => :json
  end

  def get_route_without_token(url)
    get url
  end

  def get_route_with_token(url, token)
    headers = { :HTTP_AUTHORIZATION => "Bearer #{token}" }
    get url, :headers => headers
  end

  def expect_json_header
    expect(response.header['Content-Type']).to include('application/json')
  end

  private

  def tap_user_hash(email = false, password = false)
    {}.tap do |user_hash|
      user_hash[:email] = email if email
      user_hash[:password] = password if password
    end
  end
end
