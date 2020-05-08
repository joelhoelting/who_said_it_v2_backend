module UsersHelper
  RECAPTCHA_MINIMUM_SCORE = 0.5

  def verify_recaptcha(recaptcha_action, token)
    binding.pry
    secret_key = Rails.application.credentials.RECAPTCHA[:SECRET_KEY]

    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)

    json = JSON.parse(response.body)

    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
  end

  def passwords_match?(password1, password2)
    return password1 == password2
  end
end

