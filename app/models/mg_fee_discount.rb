class MgFeeDiscount < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_fee_category)
  belongs_to(:mg_school)
end
