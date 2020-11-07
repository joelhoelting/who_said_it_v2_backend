require 'net/https'

class ApplicationController < ActionController::API
  before_action :authorized

  JWT_SECRET = Rails.application.credentials.JWT[:SECRET_KEY]

  def encode_token(payload)
    # payload => {:user_id => 5 }
    payload[:exp] = Time.now.to_i + 4 * 3600
    # payload[:exp] = Time.now.to_i + 50
    JWT.encode(payload, JWT_SECRET)
    # jwt string: "eyJhbGciOiJIUzI1NiJ9.eyJiZWVmIjoic3RlYWsifQ._IBTHTLGX35ZJWTCcY30tLmwU9arwdpNVxtVU0NpAuI"
  end

  def auth_header
    # { 'Authorization': 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decode_token
    if auth_header
      token = auth_header.split(' ')[1]
      # headers: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end
  
  def current_user
    if decode_token
      # decoded_token=> [{"user_id"=>2}, {"alg"=>"HS256"}]
      user_id = decode_token[0]['user_id']

      # TODO REFRESH LOGIC
      # refresh_token(user_id)

      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render :json => { :error => 'Please log in' }, :status => :unauthorized unless logged_in?
  end

end