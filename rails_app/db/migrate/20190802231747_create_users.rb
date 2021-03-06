class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.boolean :email_confirmed

      t.string :email_confirmation_token
      t.datetime :email_confirmation_sent_at
      t.datetime :email_confirmation_confirmed_at
      
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.datetime :password_reset_confirmed_at

      t.datetime :last_successful_login
      t.datetime :last_failed_login_attempt
      t.integer :failed_login_attempts, :default => 0
      t.boolean :authentication_lockout, :default => false

      t.timestamps
    end
  end
end
