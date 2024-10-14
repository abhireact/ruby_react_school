class MgOnlinePayment < ApplicationRecord
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.merchant_key.nil?
      self.merchant_key=self.merchant_key.strip
    end
    unless self.merchant_id.nil?
      self.merchant_id=self.merchant_id.strip
    end
  end
end
