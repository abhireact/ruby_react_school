class MgCanteenBalanceAmount < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_canteen_bill_detail)
end
