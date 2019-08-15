module AuthRequestHelpers
  def sign_up_user(email=false, password=false)
    headers = { :CONTENT_TYPE => "application/json" }
    user_hash = tap_user_hash(email, password)
    post "/api/v1/signup", :params => user_hash.to_json, :headers => headers
  end
  
  def sign_in_user(email, password)
    headers = { :CONTENT_TYPE => "application/json" }
    user_hash = tap_user_hash(email, password)
    post "/api/v1/signin", :params => user_hash.to_json, :headers => headers
  end

  def get_route_without_token(url)
    get url
  end

  def get_route_with_token(url, token)
    headers = { :HTTP_AUTHORIZATION => "Bearer #{token}" }
    get url, :headers => headers
  end

  private

  def tap_user_hash(email=false, password=false)
    {}.tap do |user_hash| 
      user_hash[:email] = email if email
      user_hash[:password] = password if password
    end
  end
end


