# frozen_string_literal: true

require 'json'
require 'support/requests/auth_request_helpers'
require 'support/general_helpers'

RSpec.configure do |c|
  c.include AuthRequestHelpers
  c.include GeneralHelpers
end

RSpec.describe 'Authentication Requests', :type => :request do
  let(:valid_email) { 'validuser@valid.com' }
  let(:valid_password) { 'validpassword123' }
  let(:valid_email_two) { 'test@test.com' }
  let(:valid_password_two) { 'test123' }

  context 'when signing up user' do
    before do
      sign_up_user(valid_email, valid_password)
    end

    it 'fails to sign up a user without email address' do
      sign_up_user(nil, valid_password)

      expect_json_header
      expect(response.status).to eq 406
      expect(response_body_to_json).to eq({ 'error_msg' => 'Failed to create user' })
    end

    it 'fails to sign up a user without password' do
      sign_up_user('test@test.com', nil)

      expect_json_header
      expect(response.status).to eq 406
      expect(response_body_to_json).to eq({ 'error_msg' => 'Failed to create user' })
    end

    it 'fails to sign up a user who already exists' do
      sign_up_user(valid_email, valid_password)

      expect(response.status).to eq 409
      expect(response_body_to_json).to include({ 'error_msg' => 'User with that email address already exists' })
    end

    it 'signs up a user with valid email/password' do
      sign_up_user(valid_email_two, valid_password_two)

      expect_json_header
      expect(response.status).to eq 201
      expect(response_body_to_json).to include({ 'success_msg' => "Confirmation email sent to #{User.last.email}" })
    end
  end

  context 'when confirming email address' do
    before do
      sign_up_user(valid_email_two, valid_password_two)
    end

    let(:user) { User.find_by(:email => valid_email_two) }

    it 'receives an email with a confirmation link' do
      last_email_sent = ActionMailer::Base.deliveries[-1].encoded
      emailed_token = last_email_sent.scan(%r{(?<=http://localhost:8080/confirm_email/).{64}})[0]

      expect(User.last.email_confirmation_token).to eq(emailed_token)
    end

    it 'user cannot login until visiting email confirmation link' do
      sign_in_user(valid_email_two, valid_password_two)

      expect_json_header
      expect(response.status).to eq 403
      expect(response_body_to_json).to include({ 'error_msg' => 'Please confirm your email address' })
    end

    it 'user can login after confirming email address' do
      confirm_email(user.email_confirmation_token)
      sign_in_user(valid_email_two, valid_password_two)

      expect_json_header
      expect(response.status).to eq 202
      expect(response_body_to_json).to include({ 'success_msg' => 'Sign in successful' })
    end
  end

  context 'when signing in user' do
    before do
      sign_up_user(valid_email_two, valid_password_two)
    end

    it 'fails to sign a user with wrong credentials' do
      sign_in_user(valid_email_two, 'invaliduser123')

      expect_json_header
      expect(response.status).to eq 401
      expect(response_body_to_json).to include({ 'error_msg' => 'Password is invalid.' })
    end

    it 'locks a user out of their account if they fail to login too many times' do
      7.times { sign_in_user(valid_email_two, 'invaliduser123') }

      expect(response_body_to_json).to include({ 'error_msg' => 'Password is invalid. 1 attempts remaining.' })
      sign_in_user(valid_email_two, 'invaliduser123')
      expect(response_body_to_json).to include({ 'error_msg' => 'You have logged in too many times. Please wait 5 minutes.'})
    end
  end
end
