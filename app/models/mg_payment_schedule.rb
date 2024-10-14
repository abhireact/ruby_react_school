class MgPaymentSchedule < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_financial_year)
end
