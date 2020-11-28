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
    render :json => { :error_msg => 'Please log in' }, :status => :unauthorized unless logged_in?
  end

  RECAPTCHA_MINIMUM_SCORE = 0.5

  def verify_recaptcha(recaptcha_action, token)
    secret_key = Rails.application.credentials.RECAPTCHA[:SECRET_KEY]

    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)

    json = JSON.parse(response.body)

    recaptcha_valid = json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
    
    if !recaptcha_valid
      render :json => { :error_msg => 'Authentication Failure' }, :status => :unauthorized
      return false
    end

    return true
  end
end