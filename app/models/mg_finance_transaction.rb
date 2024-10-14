class MgFinanceTransaction < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_finance_fee)
  belongs_to(:mg_fee_category)
  belongs_to(:mg_school)
end
