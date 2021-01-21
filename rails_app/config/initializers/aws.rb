aws_secrets = Rails.application.credentials.aws
access_key_id = aws_secrets[:access_key_id]
secret_access_key = aws_secrets[:secret_access_key]
region = aws_secrets[:region]

creds = Aws::Credentials.new(access_key_id, secret_access_key)

Aws::Rails.add_action_mailer_delivery_method(
  :ses,
  :credentials => creds,
  :region => region
)
