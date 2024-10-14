class MgHostelAttendance < ApplicationRecord
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
  belongs_to(:mg_hostel_detail)
  belongs_to(:mg_student)
end
