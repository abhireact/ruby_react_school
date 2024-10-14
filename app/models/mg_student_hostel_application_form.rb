class MgStudentHostelApplicationForm < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to(:mg_course)
  belongs_to(:mg_guardian)
end
