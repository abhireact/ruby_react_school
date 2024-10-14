class MgStudentAttandance < ApplicationRecord
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  belongs_to(:mg_student)
end
