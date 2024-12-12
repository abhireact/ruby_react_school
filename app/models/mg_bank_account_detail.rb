class MgBankAccountDetail < ApplicationRecord
  belongs_to :mg_employee, optional: true
  belongs_to :mg_school
end
