class MgBankAccountDetail < ApplicationRecord
  belongs_to(:mg_employees)
  belongs_to(:mg_school)
end
