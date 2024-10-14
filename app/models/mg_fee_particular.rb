class MgFeeParticular < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_student_category)
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  belongs_to(:mg_fee_category)
  has_many :mg_finance_transaction_details,  dependent: :destroy 
  belongs_to(:mg_particular_type)
end
