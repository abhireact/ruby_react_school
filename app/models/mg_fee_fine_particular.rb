class MgFeeFineParticular < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  belongs_to(:mg_batch)
  belongs_to(:mg_inventory_item)
  belongs_to(:mg_laboratory_subject)
  belongs_to(:mg_inventory_fine_particular)
  has_many :mg_finance_transaction_details,  dependent: :destroy 
  belongs_to(:mg_student_category)
  belongs_to(:student)
end
