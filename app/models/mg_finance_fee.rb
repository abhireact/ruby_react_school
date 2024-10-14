class MgFinanceFee < ApplicationRecord
  belongs_to(:mg_fee_collection)
  belongs_to(:mg_student)
  belongs_to(:mg_school)
  has_many :mg_payment_gateways,  dependent: :destroy 
end
