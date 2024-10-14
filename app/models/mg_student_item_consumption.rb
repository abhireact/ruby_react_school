class MgStudentItemConsumption < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_course)
  belongs_to(:mg_item_consumption)
  belongs_to(:mg_student)
end
