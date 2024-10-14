class MgFeeFineDue < ApplicationRecord
  belongs_to(:mg_fee_fine)
  belongs_to(:mg_school)
end
