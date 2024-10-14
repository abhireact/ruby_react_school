class MgFeeCollectionParticular < ApplicationRecord
  belongs_to(:mg_fee_collection)
  belongs_to(:mg_student_category)
  belongs_to(:mg_student)
  belongs_to(:mg_school)
end
