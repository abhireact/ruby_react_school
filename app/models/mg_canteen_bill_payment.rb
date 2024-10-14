class MgCanteenBillPayment < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_canteen_bill_detail)
  belongs_to(:mg_food_item)
end
