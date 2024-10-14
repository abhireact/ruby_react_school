class MgPaymentGateway < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  belongs_to(:mg_wing)
  belongs_to(:alumni)
  belongs_to(:mg_finance)
  belongs_to(:mg_master_payment_type)
end
