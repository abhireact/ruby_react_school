class MgInventoryFineParticular < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_fee_fine_particulars,  dependent: :destroy 
end
