class MgFeeCollectionDiscount < ApplicationRecord
  belongs_to(:mg_fee_collection)
  belongs_to(:mg_school)
end
