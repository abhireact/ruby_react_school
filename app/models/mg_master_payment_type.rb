class MgMasterPaymentType < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  has_many :mg_payment_gateways,  dependent: :destroy 
  has_many :mg_alumnis,  through: :mg_payment_gateways, dependent: :destroy 
end
