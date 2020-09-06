# frozen_string_literal: true

class User < ApplicationRecord
  include Spree::UserMethods
  include Discard::Model

  has_secure_password
  encrypts :email, :mobile
  blind_index :email, :mobile

  validates :first_name, :last_name, presence: true
  validates :email, :mobile, uniqueness: true
  validates :password, presence: true

  scope :admin, -> { includes(:spree_roles).where("#{Role.table_name}.name" => "admin") }

  def self.admin_created?
    User.admin.count > 0
  end

  def admin?
    has_spree_role?('admin')
  end

  protected

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end
end
