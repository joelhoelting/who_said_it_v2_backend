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
    it 'sends user a confirmation email after sign up' do
      expect(ActionMailer::Base.deliveries.length).to eq(0)
      sign_up_user(valid_email_two, valid_password_two)
      expect(ActionMailer::Base.deliveries.length).to eq(1)
    end

    it 'receives an email with a confirmation link' do
      sign_up_user(valid_email_two, valid_password_two)
      last_email_sent = ActionMailer::Base.deliveries[-1].encoded
      emailed_token = last_email_sent.scan(%r{(?<=http://localhost:8080/confirm_email/).{64}})[0]

      expect(User.last.email_confirmation_token).to eq(emailed_token)
    end
  end

  # context 'when signing in user' do
  #   it 'fails to sign a user with wrong credentials' do
  #     sign_in_user('validuser@valid.com', 'invaliduser123')
  #     expect(response.header['Content-Type']).to include('application/json')
  #     expect(response.status).to eq 401
  #     expect(response_body_to_json['error']).to eq('Invalid credentials')
  #   end

  #   # it 'succeeds when signing in an existing user' do
  #   #   sign_in_user('validuser@valid.com', 'validuser123')
  #   #   current_user = response_body_to_json['user']

  #   #   expect(response.header['Content-Type']).to include('application/json')
  #   #   expect(response.status).to eq 202
  #   #   expect(User.find_by(email: 'validuser@valid.com').id).to eq(current_user['id'])
  #   # end
  # end

  # context 'authorized resources require a JWT' do
  #   it 'fails in accessing protected route (/profile) without token' do
  #     get_route_without_token('/api/v1/profile')
  #     expect(response.status).to eq 401
  #     expect(response_body_to_json['message']).to eq 'Please log in'
  #   end

  #   it 'succeeds in accessing protected route (/profile) with token' do
  #     sign_in_user('validuser@valid.com', 'validuser123')
  #     token = response_body_to_json['jwt']
  #     get_route_with_token('/api/v1/profile', token)
  #     user_response = response_body_to_json['user']
  #     expect(@valid_user.id).to eq(user_response['id'])
  #   end
  # end
end
