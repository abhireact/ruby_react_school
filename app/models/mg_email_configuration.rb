class MgEmailConfiguration < ApplicationRecord
  belongs_to(:mg_school)
  attr_accessor(:password)
  before_save(:encrypt_password)
  before_update(:encrypt_password)

  def encrypt_password
    if password.present?
      self.salt=BCrypt::Engine.generate_salt
      self.hashed_password=BCrypt::Engine.hash_secret(password, salt)
    end
  end
end
