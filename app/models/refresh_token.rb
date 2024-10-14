class RefreshToken < ApplicationRecord
  belongs_to(:mg_user)
  attr_accessor(:token)

  def self.find_by_token(token)
    crypted_token = Digest::SHA256.hexdigest(token)
    RefreshToken.find_by({ crypted_token: })
  end
  private
end
