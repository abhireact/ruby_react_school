class MgResourcePurchase < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_resource_informations,  dependent: :destroy 
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.vendor_name.nil?
      self.vendor_name=self.vendor_name.strip
    end
  end
end
