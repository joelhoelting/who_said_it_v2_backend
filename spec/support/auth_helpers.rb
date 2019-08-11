module AuthHelpers
  def sign_up_user(email, password)
    headers = { "CONTENT_TYPE" => "application/json" }
    json_params = {:email => email, :password => password }.to_json
    post "/api/v1/signup", :params => json_params, :headers => headers
  end
  
  def sign_in_user(email, password)
    headers = { "CONTENT_TYPE" => "application/json" }
    json_params = {:email => email, :password => password }.to_json
    post "/api/v1/signin", :params => json_params, :headers => headers
  end

  def sign_in_and_get_token(email, password)
    headers = { "CONTENT_TYPE" => "application/json" }
    json_params = {:email => email, :password => password }.to_json
    post "/api/v1/signin", :params => json_params, :headers => headers
  end

  def get_route(url)
    get url
  end

  def get_protected_route(url, token)
    headers = { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
    get url, :headers => headers
  end

  private

    def response_body_to_json
      JSON.parse(response.body)
    end
end


