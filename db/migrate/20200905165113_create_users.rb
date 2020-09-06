# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :first_name, null: false
      t.string  :last_name, null: false
      t.text    :email_ciphertext, index: { unique: true }
      t.text    :mobile_ciphertext, index: { unique: true }
      t.string  :password_digest
      t.bigint  :ship_address_id, index: true
      t.bigint  :bill_address_id, index: true

      t.bigint   :login_count, default: 0, null: false
      t.bigint   :failed_login_count, default: 0, null: false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.datetime :discarded_at, index: true
      t.string   :user_agent
      t.string   :current_login_ip
      t.string   :last_login_ip

      t.timestamps
    end
  end
end
