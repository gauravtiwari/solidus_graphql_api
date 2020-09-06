class User < ApplicationRecord
  has_secure_password
  encrypts :email, :mobile
  blind_index :email, :mobile

  validates :first_name, :last_name, presence: true
  validates :email, :mobile, uniqueness: true
  validates :password, presence: true
end
