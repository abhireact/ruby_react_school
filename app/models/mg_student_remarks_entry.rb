class MgStudentRemarksEntry < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
end
